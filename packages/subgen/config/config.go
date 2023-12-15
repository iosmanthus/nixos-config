package config

import (
	"encoding/json"
	"fmt"

	"github.com/google/go-jsonnet"
	"github.com/iosmanthus/subgen/secrets"
	"github.com/iosmanthus/subgen/types"
)

type Config struct {
	Addr     string    `json:"addr"`
	Profiles []Profile `json:"profiles"`
	ExprPath string    `json:"exprPath"`
}

type Profile struct {
	types.Metadata `json:",inline"`
	Auth           Authenticator `json:"auth"`
	Inputs         []Input       `json:"inputs"`
	Expr           Expr          `json:"expr"`
}

type Authenticator struct {
	HashedPassword string `json:"hashedPassword"`
}

type InputType string

const (
	InputTypeRemote InputType = "remote"
	InputTypeLocal  InputType = "local"
)

type Input struct {
	types.Metadata `json:",inline"`
	*RemoteInput   `json:",inline"`
	*LocalInput    `json:",inline"`
}

func (i *Input) UnmarshalJSON(data []byte) error {
	type input Input
	var ii input
	err := json.Unmarshal(data, &ii)
	if err != nil {
		return err
	}
	switch InputType(ii.Type) {
	case InputTypeLocal:
		*i = Input{
			Metadata:   ii.Metadata,
			LocalInput: ii.LocalInput,
		}
	case InputTypeRemote:
		*i = Input{
			Metadata:    ii.Metadata,
			RemoteInput: ii.RemoteInput,
		}
	default:
		return fmt.Errorf("unknown input type: %s", ii.Type)
	}
	return nil
}

type RemoteInput struct {
	types.Metadata `json:",inline"`
	Url            string `json:"url"`
}

type LocalInput struct {
	types.Metadata `json:",inline"`
	Value          json.RawMessage `json:"value"`
}

type ExprType string

const (
	ExprTypeLocal  ExprType = "local"
	ExprTypeRemote ExprType = "remote"
)

type Expr struct {
	types.Metadata `json:",inline"`
	*LocalExpr     `json:",inline"`
	*RemoteExpr    `json:",inline"`
}

func (e *Expr) UnmarshalJSON(data []byte) error {
	type expr Expr
	var ee expr

	err := json.Unmarshal(data, &ee)
	if err != nil {
		return err
	}
	switch ExprType(ee.Type) {
	case ExprTypeLocal:
		*e = Expr{
			Metadata:  ee.Metadata,
			LocalExpr: ee.LocalExpr,
		}
	case ExprTypeRemote:
		*e = Expr{
			Metadata:   ee.Metadata,
			RemoteExpr: ee.RemoteExpr,
		}
	default:
		return fmt.Errorf("unknown expr type: %s", ee.Type)
	}
	return nil
}

type LocalExpr struct {
	Path string `json:"path"`
}

type RemoteExpr struct {
	Url    string `json:"url"`
	Sha256 string `json:"sha256"`
}

func New(path string, s *secrets.Secrets) (*Config, error) {
	vm := jsonnet.MakeVM()
	vm.StringOutput = true

	data, err := vm.EvaluateAnonymousSnippet(path, fmt.Sprintf(`
local c = import '%s';
local secrets = %s;
std.manifestJsonEx(c(secrets),indent="  ")
`, path, s.String()))
	if err != nil {
		return nil, err
	}

	var c Config
	err = json.Unmarshal([]byte(data), &c)
	if err != nil {
		return nil, err
	}

	return &c, nil
}
