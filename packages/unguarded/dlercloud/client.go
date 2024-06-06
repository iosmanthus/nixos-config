package dlercloud

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"strconv"
	"time"

	"github.com/PuerkitoBio/goquery"
)

const (
	relayPath = "user/cusrelay"
)

type Relay struct {
	SourceName string `json:"source_name"`
	SourceHost string `json:"source_host"`
	SourcePort int    `json:"source_port"`

	TargetHost string `json:"target_host"`
	TargetPort int    `json:"target_port"`
}

type Auth struct {
	UID   string `json:"uid"`
	Email string `json:"email"`
	Key   string `json:"key"`
}

type Client struct {
	endpoint string
	inner    *http.Client
}

func NewClient(endpoint string, auth Auth) (*Client, error) {
	u, err := url.Parse(endpoint)
	if err != nil {
		return nil, err
	}

	jar, err := cookiejar.New(nil)
	if err != nil {
		return nil, err
	}

	expireIn := time.Now().Add(time.Hour)
	jar.SetCookies(u, []*http.Cookie{
		{Name: "uid", Value: auth.UID},
		{Name: "email", Value: auth.Email},
		{Name: "key", Value: auth.Key},
		{Name: "expire_in", Value: fmt.Sprintf("%d", expireIn.Unix())},
	})

	inner := &http.Client{
		Jar: jar,
	}

	return &Client{
		endpoint: endpoint,
		inner:    inner,
	}, nil
}

func (c *Client) List(ctx context.Context) ([]*Relay, error) {
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/%s", c.endpoint, relayPath), nil)
	if err != nil {
		return nil, err
	}

	resp, err := c.inner.Do(req.WithContext(ctx))
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
	doc.Find("table").Find("tr").EachWithBreak(func(i int, s *goquery.Selection) bool {
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
			SourceName: s.ChildrenFiltered("td:nth-child(3)").Text(),
			SourceHost: s.ChildrenFiltered("td:nth-child(4)").Text(),
			TargetHost: s.ChildrenFiltered("td:nth-child(6)").Text(),

			SourcePort: sport,
			TargetPort: tport,
		})

		return true
	})

	return relays, nil
}
