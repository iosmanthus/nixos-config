package main

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sagernet/sing-box/common/srs"
	"github.com/sagernet/sing-box/constant"
	"github.com/sagernet/sing-box/option"
	"github.com/sagernet/sing/common"
)

type StatusServer struct {
	server *gin.Engine
	addr   string
	rcd    Recorder
}

func NewStatusServer(addr string, rcd Recorder) *StatusServer {
	srv := &StatusServer{
		addr: addr,
		rcd:  rcd,
	}

	r := gin.New()
	r.GET("/json", func(c *gin.Context) {
		srv.handleJSON(c)
	})

	r.GET("/binary", func(c *gin.Context) {
		srv.handleBinary(c)
	})

	srv.server = r

	return srv
}

func (s *StatusServer) buildHeadlessRule() (*option.DefaultHeadlessRule, error) {
	var rule option.DefaultHeadlessRule
	domain, err := s.rcd.List()
	if err != nil {
		return nil, err
	}
	rule.Domain = domain
	rule.DomainSuffix = common.Map(domain, func(s string) string {
		return fmt.Sprintf(".%s", s)
	})
	return &rule, nil
}

func (s *StatusServer) handleJSON(c *gin.Context) {
	headlessRule, err := s.buildHeadlessRule()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	var ruleSet option.PlainRuleSetCompat
	ruleSet.Version = constant.RuleSetVersion1
	ruleSet.Options.Rules = []option.HeadlessRule{
		{
			Type:           constant.RuleTypeDefault,
			DefaultOptions: *headlessRule,
		},
	}
	c.JSON(http.StatusOK, ruleSet)
}

func (s *StatusServer) handleBinary(c *gin.Context) {
	headlessRule, err := s.buildHeadlessRule()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}
	var ruleSet option.PlainRuleSet
	ruleSet.Rules = []option.HeadlessRule{
		{
			Type:           constant.RuleTypeDefault,
			DefaultOptions: *headlessRule,
		},
	}
	_ = srs.Write(c.Writer, ruleSet)
}

func (s *StatusServer) Run() error {
	return s.server.Run(s.addr)
}
