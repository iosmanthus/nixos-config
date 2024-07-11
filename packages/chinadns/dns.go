package main

import (
	"context"
	"log/slog"
	"time"

	"github.com/miekg/dns"
)

type DNSServer struct {
	server *dns.Server
	rcd    Recorder
}

func NewDNSServer(addr string, rcd Recorder) *DNSServer {
	srv := &DNSServer{
		rcd: rcd,
	}
	inner := &dns.Server{
		Net:  "udp",
		Addr: addr,
	}
	inner.Handler = srv
	srv.server = inner
	return srv
}

func (d *DNSServer) ServeDNS(w dns.ResponseWriter, r *dns.Msg) {
	var (
		c = new(dns.Client)
		m = new(dns.Msg).SetReply(r)
	)

	ctx, cancel := context.WithTimeout(context.Background(), *timeout)
	defer cancel()

	begin := time.Now()
	resp, _, err := c.ExchangeContext(ctx, r, *upstream)
	if err != nil {
		slog.Error("failed to exchange", "error", err)
		_ = w.WriteMsg(m.SetRcode(r, dns.RcodeServerFailure))
		return
	}
	_ = w.WriteMsg(resp)
	slog.Debug("exchange completed", "question", r.Question, "rtt", time.Since(begin))

	d.rcd.Record(resp)
}

func (d *DNSServer) Run() error {
	return d.server.ListenAndServe()
}
