package profile

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/iosmanthus/subgen/auth"
	"github.com/iosmanthus/subgen/expr"
	"github.com/iosmanthus/subgen/input"
	"github.com/iosmanthus/subgen/types"
)

type Profile struct {
	Metadata types.Metadata
	Auth     auth.Authenticator
	Inputs   map[string]input.Input
	Expr     expr.Expr
}

type Params struct {
	Token string `form:"token" binding:"required"`
}

func (p *Profile) Generate(ctx context.Context, params Params, options map[string][]string) (string, error) {
	err := p.Auth.Auth(ctx, params.Token)
	if err != nil {
		return "", fmt.Errorf("fail to authenicate: %w", err)
	}

	args := make(map[string]*input.NamedJsonMessage)
	// Evaluate the inputs first
	for k, v := range p.Inputs {
		arg, err := v.Value(ctx)
		if err != nil {
			return "", fmt.Errorf("fail to get the value of input %s: %w", v.Metadata().Name, err)
		}
		args[k] = arg
	}

	// Evaluate the options, might overwrite the inputs
	for k, v := range options {
		var value any
		if len(v) == 1 {
			value = v[0]
		} else {
			value = v
		}

		vv, err := json.Marshal(value)
		if err != nil {
			return "", fmt.Errorf("fail to marshal the value of option %s: %w", k, err)
		}
		args[k] = &input.NamedJsonMessage{
			Name:  k,
			Value: vv,
		}
	}

	result, err := p.Expr.Eval(ctx, args)
	if err != nil {
		return "", fmt.Errorf("fail to evaluate the expression %s: %w", p.Expr.Metadata().Name, err)
	}
	return result, nil
}
