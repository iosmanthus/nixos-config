package input

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"

	"github.com/iosmanthus/subgen/types"
)

var (
	_ Input = (*remoteInput)(nil)
	_ Input = (*localInput)(nil)
)

type NamedJsonMessage struct {
	Name  string          `json:"name"`
	Value json.RawMessage `json:"value"`
}
type Input interface {
	Metadata() *types.Metadata
	Value(ctx context.Context) (*NamedJsonMessage, error)
}

func NewRemote(metadata types.Metadata, url string) Input {
	return &remoteInput{
		metadata: metadata,
		url:      url,
	}
}

type remoteInput struct {
	metadata types.Metadata
	url      string
}

type remoteValue struct {
	Data string `json:"data"`
}

func (r *remoteInput) Metadata() *types.Metadata {
	return &r.metadata
}

func redactErrorURL(err error) {
	var ue *url.Error
	if errors.As(err, &ue) {
		ue.URL = "<redacted>"
	}
}

func (r *remoteInput) Value(ctx context.Context) (*NamedJsonMessage, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, r.url, nil)
	if err != nil {
		return nil, err
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		redactErrorURL(err)
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("fail to get the value of input %s: %s", r.metadata.Name, resp.Status)
	}
	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	val := remoteValue{
		Data: string(data),
	}
	valBytes, err := json.Marshal(val)
	if err != nil {
		return nil, err
	}

	return &NamedJsonMessage{
		Name:  r.metadata.Name,
		Value: valBytes,
	}, nil
}

func NewLocal(metadata types.Metadata, value json.RawMessage) Input {
	return &localInput{
		metadata: metadata,
		value:    value,
	}
}

type localInput struct {
	metadata types.Metadata
	value    json.RawMessage
}

func (l *localInput) Metadata() *types.Metadata {
	return &l.metadata
}

func (l *localInput) Value(_ context.Context) (*NamedJsonMessage, error) {
	return &NamedJsonMessage{
		Name:  l.metadata.Name,
		Value: l.value,
	}, nil
}
