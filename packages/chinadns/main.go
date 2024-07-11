package main

import "C"
import (
	"flag"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/dgraph-io/badger/v4"
	"github.com/gin-gonic/gin"
	"github.com/sagernet/sing-box/adapter"
	"github.com/sagernet/sing-box/common/srs"
	"github.com/sagernet/sing-box/route"
)

var (
	addr         = flag.String("addr", ":53", "dns address to listen on")
	statusAddr   = flag.String("status-addr", ":8080", "http address to listen on")
	upstream     = flag.String("upstream", "8.8.8.8:53", "upstream DNS server")
	timeout      = flag.Duration("timeout", 10*time.Second, "timeout for upstream DNS server")
	geoipCN      = flag.String("geoip-cn", "./geoip-cn.srs", "geoip-cn database")
	geositeCN    = flag.String("geosite-cn", "./geosite-china-list.srs", "geosite-cn database")
	geositeNotCN = flag.String(
		"geosite-not-cn",
		"./geosite-geolocation-!cn.srs",
		"geosite-geolocation-!cn database",
	)
	state = flag.String("state", "./data", "state file")
)

func main() {
	flag.Parse()
	gin.SetMode(gin.ReleaseMode)

	start := time.Now()
	paths := []string{*geoipCN, *geositeCN, *geositeNotCN}
	rules := make([][]adapter.HeadlessRule, 0, len(paths))
	for _, path := range paths {
		rs, err := readSRS(path)
		if err != nil {
			slog.Error("failed to read srs", "path", path, "error", err)
			os.Exit(1)
		}
		rules = append(rules, rs)
	}
	slog.Info("read srs", "paths", paths, "duration", time.Since(start))

	db, err := badger.Open(badger.DefaultOptions(*state))
	if err != nil {
		slog.Error("failed to open badger", "error", err)
		os.Exit(1)
	}

	rcd := NewRecorder(rules[0], rules[1], rules[2], db)
	dnsSrv := NewDNSServer(*addr, rcd)
	statusSrv := NewStatusServer(*statusAddr, rcd)

	ch := make(chan os.Signal, 1)
	signal.Notify(ch, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)

	errs := make(chan error, 2)
	go func() {
		slog.Info("starting status server", "addr", *statusAddr)
		errs <- statusSrv.Run()
	}()

	go func() {
		slog.Info("starting dns server", "addr", *addr)
		errs <- dnsSrv.Run()
	}()

	select {
	case <-ch:
		return
	case err := <-errs:
		if err != nil {
			slog.Error("fail to start server", "error", err)
		}
	}
}

func readSRS(path string) ([]adapter.HeadlessRule, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}

	data, err := srs.Read(f, false)
	if err != nil {
		return nil, err
	}

	rules := make([]adapter.HeadlessRule, 0, len(data.Rules))
	for _, rule := range data.Rules {
		r, err := route.NewHeadlessRule(nil, rule)
		if err != nil {
			return nil, err
		}
		rules = append(rules, r)
	}

	return rules, nil
}
