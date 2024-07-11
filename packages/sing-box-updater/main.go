package main

import (
	"bytes"
	"context"
	"errors"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
	"time"

	"github.com/coreos/go-systemd/v22/dbus"
)

var (
	sbPath   = flag.String("sb-path", "", "path of sing-box binary")
	url      = flag.String("url", "", "config url")
	path     = flag.String("path", "/var/lib/sing-box/config.json", "config path")
	interval = flag.Duration("interval", time.Minute*15, "config update interval")
	service  = flag.String("service", "sing-box.service", "systemd service name")
)

var (
	lastPoll time.Time
	errSkip  = errors.New("skip")
)

func main() {
	flag.Parse()
	conn, err := dbus.NewWithContext(context.TODO())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	if u := os.Getenv("URL"); u != "" {
		*url = u
	}
	if *url == "" {
		log.Fatal("url is required")
	}
	if *sbPath == "" {
		log.Fatal("sb-path is required")
	}

	ch := make(chan os.Signal, 1)
	signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM)

	log.Println("config updater started")
	var lastPoll time.Time
	ticker := time.NewTicker(*interval)
	for {
		if time.Since(lastPoll) < *interval {
			continue
		}

		data, err := os.ReadFile(*path)
		if err != nil && !os.IsNotExist(err) {
			continue
		}

		// If the config file is not exist, update it.
		err = update(conn, data)
		if errors.Is(err, errSkip) {
			continue
		} else if err != nil {
			log.Println("update failed:", err)
			continue
		}

		lastPoll = time.Now()
		log.Println("config updated")

		select {
		case <-ch:
			return
		case <-ticker.C:
		}
	}
}

func update(dc *dbus.Conn, old []byte) error {
	resp, err := http.Get(*url)
	if err != nil {
		return fmt.Errorf("failed to fetch config: %w", err)
	}

	cfgData, err := io.ReadAll(resp.Body)
	_ = resp.Body.Close()
	if err != nil {
		return fmt.Errorf("failed to read config: %w", err)
	}

	if bytes.Equal(old, cfgData) {
		return errSkip
	}

	f, err := os.CreateTemp("./", "config.json.tmp")
	if err != nil {
		return err
	}
	defer os.Remove(f.Name())
	_, err = f.Write(cfgData)
	if err != nil {
		return err
	}

	err = exec.Command(*sbPath, "check", "-c", f.Name()).Run()
	if err != nil {
		return fmt.Errorf("config check failed: %w", err)
	}

	err = os.WriteFile(*path, cfgData, 0644)
	if err != nil {
		return fmt.Errorf("failed to write config: %w", err)
	}

	_, err = dc.RestartUnitContext(context.TODO(), *service, "replace", nil)
	if err != nil {
		return fmt.Errorf("failed to restart service: %w", err)
	}

	return nil
}
