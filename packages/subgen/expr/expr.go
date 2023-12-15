package expr

import (
	"context"
	"fmt"

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
	vm       *jsonnet.VM
}

func NewLocal(metadata types.Metadata, path string) Expr {
	vm := jsonnet.MakeVM()
	vm.StringOutput = true
	return &localExpr{
		metadata: metadata,
		path:     path,
		vm:       vm,
	}
}

func (l *localExpr) Metadata() *types.Metadata {
	return &l.metadata
}

func (l *localExpr) Eval(_ context.Context, args ...*input.NamedJsonMessage) (string, error) {
	var namedArgs string
	for _, arg := range args {
		namedArgs += fmt.Sprintf("%s=%s,", arg.Name, string(arg.Value))
	}
	code := fmt.Sprintf(
		`
local g = import '%s';
g(%s)
`, l.path, namedArgs)
	result, err := l.vm.EvaluateAnonymousSnippet(l.path, code)
	return result, err
}
