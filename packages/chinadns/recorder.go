package main

import (
	"log/slog"
	"net/netip"

	"github.com/dgraph-io/badger/v4"
	"github.com/miekg/dns"
	"github.com/sagernet/sing-box/adapter"
	boxdns "github.com/sagernet/sing-dns"
	"github.com/sagernet/sing/common"
)

var _ Recorder = &recorder{}

const (
	// while no record is found, use this default domain
	defaultDomain = "bilibili.com"
)

type Recorder interface {
	List() ([]string, error)
	Record(m *dns.Msg)
}

type recorder struct {
	geoipCN      []adapter.HeadlessRule
	geositeCN    []adapter.HeadlessRule
	geositeNotCN []adapter.HeadlessRule
	db           *badger.DB
}

func NewRecorder(
	geoipCN []adapter.HeadlessRule,
	geositeCN []adapter.HeadlessRule,
	geositeNotCN []adapter.HeadlessRule,
	db *badger.DB,
) Recorder {
	return &recorder{
		geoipCN:      geoipCN,
		geositeCN:    geositeCN,
		geositeNotCN: geositeNotCN,
		db:           db,
	}
}

func (r *recorder) Record(m *dns.Msg) {
	if !r.accept(m) {
		return
	}

	keys := make([]string, 0, len(m.Question))
	for _, q := range m.Question {
		key := q.Name
		var i, dots int
		for i = len(key) - 2; i >= 0; i-- {
			if key[i] == '.' {
				dots++
			}
			if dots > 1 {
				break
			}
		}

		if dots > 1 {
			key = key[i+1 : len(key)-1]
		} else {
			key = key[:len(key)-1]
		}

		keys = append(keys, key)
	}

	err := r.db.Update(func(txn *badger.Txn) error {
		for _, key := range keys {
			err := txn.Set([]byte(key), []byte{})
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		slog.Error("failed to update db", "error", err)
	}
}

func getDomainFromMsg(m *dns.Msg) string {
	if len(m.Question) > 0 {
		k := m.Question[0].Name
		return k[:len(k)-1]
	}
	return ""
}

func (r *recorder) accept(m *dns.Msg) bool {
	ips, _ := boxdns.MessageToAddresses(m)
	domain := getDomainFromMsg(m)

	slog.Info("checking", "ips", ips, "domain", domain)

	if common.Any(ips, func(it netip.Addr) bool {
		return it.IsPrivate()
	}) {
		return true
	}

	if common.Any(r.geositeNotCN, func(rule adapter.HeadlessRule) bool {
		return rule.Match(&adapter.InboundContext{
			Domain: domain,
		})
	}) {
		return false
	}

	if common.Any(r.geositeCN, func(rule adapter.HeadlessRule) bool {
		return rule.Match(&adapter.InboundContext{
			Domain: domain,
		})
	}) {
		return false
	}

	return common.Any(r.geoipCN, func(rule adapter.HeadlessRule) bool {
		return rule.Match(&adapter.InboundContext{
			DestinationAddresses: ips,
		})
	})
}

func (r *recorder) List() ([]string, error) {
	var list []string

	err := r.db.View(func(txn *badger.Txn) error {
		opts := badger.DefaultIteratorOptions
		opts.PrefetchValues = false
		it := txn.NewIterator(opts)
		defer it.Close()
		for it.Rewind(); it.Valid(); it.Next() {
			item := it.Item()
			key := item.Key()
			list = append(list, string(key))
		}
		return nil
	})

	if err != nil {
		return nil, err
	}

	if len(list) == 0 {
		return []string{defaultDomain}, nil
	}

	return list, nil
}
