package server

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"path"
	"sync/atomic"

	"github.com/gin-gonic/gin"
	"github.com/iosmanthus/subgen/auth"
	"github.com/iosmanthus/subgen/config"
	"github.com/iosmanthus/subgen/expr"
	"github.com/iosmanthus/subgen/input"
	"github.com/iosmanthus/subgen/profile"
	"github.com/iosmanthus/subgen/types"
)

type Server interface {
	Start(ctx context.Context) error
}

type server struct {
	ctx      context.Context
	profiles map[string]*profile.Profile
	svr      *http.Server
	started  atomic.Bool
}

func (s *server) Close() error {
	return s.svr.Shutdown(s.ctx)
}

func (s *server) Start(ctx context.Context) error {
	if !s.started.CompareAndSwap(false, true) {
		return errors.New("server is already started")
	}
	s.ctx = ctx
	errChan := make(chan error, 1)
	go func() {
		err := s.svr.ListenAndServe()
		if err != nil && !errors.Is(err, http.ErrServerClosed) {
			errChan <- err
			return
		}
	}()
	select {
	case <-ctx.Done():
		return s.Close()
	case err := <-errChan:
		return err
	}
}

func New(c *config.Config) (Server, error) {
	profiles := make(map[string]*profile.Profile)
	for _, p := range c.Profiles {
		meta := types.Metadata{
			Name: p.Name,
		}
		authenticator := auth.NewPasswordAuthenticator(p.Auth.HashedPassword)
		inputs := make(map[string]input.Input)
		for _, in := range p.Inputs {
			switch config.InputType(in.Type) {
			case config.InputTypeLocal:
				inputs[in.Name] = input.NewLocal(in.Metadata, in.LocalInput.Value)
			case config.InputTypeRemote:
				inputs[in.Name] = input.NewRemote(in.Metadata, in.RemoteInput.Url)
			case config.InputTypeExtCode:
				inputs[in.Name] = input.NewExtCode(in.Metadata, c.ExprPath, in.ExtCodeInput.Path)
			default:
				return nil, fmt.Errorf("unknown input type: %s", in.Type)
			}
		}

		var (
			e   expr.Expr
			err error
		)
		switch config.ExprType(p.Expr.Type) {
		case config.ExprTypeLocal:
			e, err = expr.NewLocal(p.Expr.Metadata, path.Join(c.ExprPath, p.Expr.LocalExpr.Path))
		case config.ExprTypeRemote:
			err = fmt.Errorf("remote expression is not supported yet")
		}

		if err != nil {
			return nil, err
		}

		prf := &profile.Profile{
			Metadata: meta,
			Auth:     authenticator,
			Inputs:   inputs,
			Expr:     e,
		}

		if _, ok := profiles[p.Name]; ok {
			return nil, fmt.Errorf("duplicate profile: %s", p.Name)
		}

		profiles[p.Name] = prf
	}

	router := gin.Default()
	svr := &http.Server{
		Addr:    c.Addr,
		Handler: router,
	}
	s := &server{
		profiles: profiles,
		svr:      svr,
	}

	router.GET("/profile/:name", s.getProfile)
	return s, nil
}

func (s *server) getProfile(c *gin.Context) {
	name := c.Param("name")
	prf, ok := s.profiles[name]
	if !ok {
		c.String(http.StatusNotFound, "profile not found")
		return
	}

	var params profile.Params
	err := c.ShouldBindQuery(&params)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	options := c.Request.URL.Query()
	// remove the token from options
	options.Del("token")

	result, err := prf.Generate(c.Request.Context(), params, options)
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		return
	}
	c.String(http.StatusOK, result)
}
