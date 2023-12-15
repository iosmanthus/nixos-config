package main

import (
	"context"
	"flag"
	"os"
	"os/signal"
	"syscall"

	"github.com/iosmanthus/subgen/config"
	"github.com/iosmanthus/subgen/secrets"
	"github.com/iosmanthus/subgen/server"
	log "github.com/sirupsen/logrus"
)

var (
	configPath  string
	secretsPath string
	exprPath    string
	addr        string
)

func init() {
	flag.StringVar(&configPath, "config", "./config.jsonnet", "path to the config file")
	flag.StringVar(&secretsPath, "secrets", "", "path to the secrets file")
	flag.StringVar(&exprPath, "expr", "", "path to the expr files")
	flag.StringVar(&addr, "addr", ":8080", "address to listen on")
}

func main() {
	flag.Parse()
	log.SetFormatter(&log.TextFormatter{
		DisableColors: true,
		FullTimestamp: true,
	})

	var (
		s   *secrets.Secrets
		err error
	)
	if secretsPath == "" {
		s = secrets.New()
	} else {
		s, err = secrets.FromFile(secretsPath)
		if err != nil {
			log.Fatalf("fail to load secrets: %v", err)
		}
	}

	cfg, err := config.New(configPath, s)
	if err != nil {
		log.Fatalf("fail to load config: %v", err)
	}
	cfg.Addr = addr
	cfg.ExprPath = exprPath

	svr, err := server.New(cfg)
	if err != nil {
		log.Fatalf("fail to create server: %v", err)
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go func() {
		err := svr.Start(ctx)
		if err != nil {
			log.Fatalf("fail to start server: %v", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Warn("shutting down server")
}
