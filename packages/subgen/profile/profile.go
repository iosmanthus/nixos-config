package profile

import (
	"context"
	"fmt"

	"github.com/iosmanthus/subgen/auth"
	"github.com/iosmanthus/subgen/expr"
	"github.com/iosmanthus/subgen/input"
	"github.com/iosmanthus/subgen/types"
)

type Profile struct {
	Metadata types.Metadata
	Auth     auth.Authenticator
	Inputs   []input.Input
	Expr     expr.Expr
}

type Params struct {
	Token string `form:"token" binding:"required"`
}

func (p *Profile) Generate(ctx context.Context, params Params) (string, error) {
	err := p.Auth.Auth(ctx, params.Token)
	if err != nil {
		return "", fmt.Errorf("fail to authenicate: %w", err)
	}
	args := make([]*input.NamedJsonMessage, 0, len(p.Inputs))
	for _, in := range p.Inputs {
		arg, err := in.Value(ctx)
		if err != nil {
			return "", fmt.Errorf("fail to get the value of input %s: %w", in.Metadata(), err)
		}
		args = append(args, arg)
	}
	result, err := p.Expr.Eval(ctx, args...)
	if err != nil {
		return "", fmt.Errorf("fail to evaluate the expression %s: %w", p.Expr.Metadata().Name, err)
	}
	return result, nil
}
