package types

import "fmt"

type Metadata struct {
	Type string `json:"type,omitempty"`
	Name string `json:"name"`
}

func (m *Metadata) String() string {
	return fmt.Sprintf(`{"type":%s,"name":%s}`, m.Type, m.Name)
}
