package dlercloud

import (
	"context"
	"crypto/tls"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	utls "github.com/refraction-networking/utls"
	"golang.org/x/net/http2"
)

var _ Client = (*client)(nil)

const (
	relayPath       = "user/cusrelay"
	relayCreatePath = "user/cusrelay/create"

	defaultUA     = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
	defaultExpiry = time.Hour * 24 * 30
)

type Relay struct {
	SourceNode string `json:"source_node"`
	SourceHost string `json:"source_host"`
	SourcePort int    `json:"source_port"`

	TargetHost string `json:"target_host"`
	TargetPort int    `json:"target_port"`
}

type CreateRelay struct {
	SourceNode string `json:"source_node" form:"source_node"`
	TargetHost string `json:"target_host" form:"target_host"`
	TargetPort string `json:"target_port" form:"target_port"`
}

type SourceNode struct {
	Name string `json:"name"`
	ID   string `json:"id"`
}

type Credential struct {
	UID   string `json:"uid" form:"uid"`
	Email string `json:"email" form:"email"`
	Key   string `json:"key" form:"key"`
}

type Client interface {
	ListRelays(ctx context.Context) ([]*Relay, error)
	ListSourceNodes(ctx context.Context) ([]*SourceNode, error)
	CreateRelay(ctx context.Context, request *CreateRelay) error
}

type client struct {
	endpoint *url.URL
	cred     Credential
	inner    *http.Client
}

func NewClient(endpoint string, cred Credential) (Client, error) {
	u, err := url.Parse(endpoint)
	if err != nil {
		return nil, err
	}

	dialTLS := func(ctx context.Context, network, addr string, cfg *tls.Config) (net.Conn, error) {
		dialer := &net.Dialer{}
		tcpConn, err := dialer.DialContext(ctx, network, addr)
		if err != nil {
			return nil, err
		}

		config := utls.Config{ServerName: cfg.ServerName, NextProtos: cfg.NextProtos}
		tlsConn := utls.UClient(tcpConn, &config, utls.HelloChrome_Auto)
		err = tlsConn.Handshake()
		if err != nil {
			return nil, err
		}

		return tlsConn, nil
	}

	cli := &http.Client{
		Transport: &http2.Transport{
			DialTLSContext: dialTLS,
		},
	}

	return &client{
		endpoint: u,
		cred:     cred,
		inner:    cli,
	}, nil
}

func (c *client) ListRelays(ctx context.Context) ([]*Relay, error) {
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/%s", c.endpoint, relayPath), nil)
	if err != nil {
		return nil, err
	}

	resp, err := c.do(ctx, req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("fail to list relays: status %s", resp.Status)
	}

	return parseHTMLRelayTable(resp.Body)
}

func parseHTMLRelayTable(reader io.Reader) ([]*Relay, error) {
	doc, err := goquery.NewDocumentFromReader(reader)
	if err != nil {
		return nil, err
	}

	var relays []*Relay
	doc.Find("#rule_table tr").EachWithBreak(func(i int, s *goquery.Selection) bool {
		if len(s.ChildrenFiltered("td").Nodes) == 0 {
			return true
		}

		var (
			sport int
			tport int
		)
		sport, err = strconv.Atoi(s.ChildrenFiltered("td:nth-child(5)").Text())
		if err != nil {
			return false
		}

		tport, err = strconv.Atoi(s.ChildrenFiltered("td:nth-child(7)").Text())
		if err != nil {
			return false
		}

		relays = append(relays, &Relay{
			SourceNode: s.ChildrenFiltered("td:nth-child(3)").Text(),
			SourceHost: s.ChildrenFiltered("td:nth-child(4)").Text(),
			TargetHost: s.ChildrenFiltered("td:nth-child(6)").Text(),

			SourcePort: sport,
			TargetPort: tport,
		})

		return true
	})

	return relays, nil
}

func (c *client) ListSourceNodes(ctx context.Context) ([]*SourceNode, error) {
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/%s", c.endpoint, relayCreatePath), nil)
	if err != nil {
		return nil, err
	}

	resp, err := c.do(ctx, req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("fail to list source nodes: status %s", resp.Status)
	}

	return parseHTMLNodes(resp.Body)
}

func parseHTMLNodes(reader io.Reader) ([]*SourceNode, error) {
	doc, err := goquery.NewDocumentFromReader(reader)
	if err != nil {
		return nil, err
	}

	var nodes []*SourceNode
	doc.Find("#source_node option").Each(func(i int, s *goquery.Selection) {
		value := s.AttrOr("value", "0")
		if value == "0" {
			return
		}

		nodes = append(nodes, &SourceNode{
			Name: s.Text(),
			ID:   value,
		})
	})

	return nodes, nil
}

func (c *client) CreateRelay(ctx context.Context, request *CreateRelay) error {
	data := url.Values{}
	data.Set("source_node", request.SourceNode)
	data.Set("dist_add", request.TargetHost)
	data.Set("port", request.TargetPort)
	data.Set("relay_mode", "0")

	req, err := http.NewRequest(http.MethodPost, fmt.Sprintf("%s/%s", c.endpoint, relayPath), strings.NewReader(data.Encode()))
	if err != nil {
		return err
	}

	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	resp, err := c.do(ctx, req)
	if err != nil {
		return err
	}

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("fail to create relay: status %s", resp.Status)
	}

	return nil
}

func (c *client) do(ctx context.Context, req *http.Request) (*http.Response, error) {
	req.Header.Set("User-Agent", defaultUA)

	req.AddCookie(&http.Cookie{
		Name:  "uid",
		Value: c.cred.UID,
	})
	req.AddCookie(&http.Cookie{
		Name:  "email",
		Value: c.cred.Email,
	})
	req.AddCookie(&http.Cookie{
		Name:  "key",
		Value: c.cred.Key,
	})
	req.AddCookie(&http.Cookie{
		Name:  "expire_in",
		Value: fmt.Sprintf("%d", time.Now().Add(defaultExpiry).Unix()),
	})

	return c.inner.Do(req.WithContext(ctx))
}
