package expr

import (
	"context"

	"github.com/google/go-jsonnet"
	"github.com/iosmanthus/subgen/input"
	"github.com/iosmanthus/subgen/types"
)

var (
	_ Expr = (*localExpr)(nil)
)

type Expr interface {
	Metadata() *types.Metadata
	Eval(ctx context.Context, args ...*input.NamedJsonMessage) (string, error)
}

type localExpr struct {
	metadata types.Metadata
	path     string
}

func NewLocal(metadata types.Metadata, path string) (Expr, error) {
	return &localExpr{
		metadata: metadata,
		path:     path,
	}, nil
}

func (l *localExpr) Metadata() *types.Metadata {
	return &l.metadata
}

func (l *localExpr) Eval(_ context.Context, args ...*input.NamedJsonMessage) (string, error) {
	vm := jsonnet.MakeVM()
	vm.StringOutput = true

	for _, arg := range args {
		vm.ExtCode(arg.Name, string(arg.Value))
	}

	return vm.EvaluateFile(l.path)
}
