package secrets

import (
	"github.com/Jeffail/gabs/v2"
	"github.com/getsops/sops/v3/decrypt"
)

type Secrets struct {
	*gabs.Container
}

func FromFile(path string) (*Secrets, error) {
	cleartext, err := decrypt.File(path, "json")
	if err != nil {
		return nil, err
	}
	container, err := gabs.ParseJSON(cleartext)
	if err != nil {
		return nil, err
	}
	return &Secrets{
		Container: container,
	}, nil
}

func New() *Secrets {
	return &Secrets{
		Container: gabs.New(),
	}
}
