package main

import (
	"flag"
	"fmt"
	"log"

	"github.com/iosmanthus/nixos-config/packages/unguarded/dlercloud"

	"github.com/gin-gonic/gin"
)

var (
	dlercloudEndpoint = flag.String("dlercloud-endpoint", "https://dlercloud.com", "dlercloud endpoint")
	addr              = flag.String("addr", "127.0.0.1:8787", "server address")
)

func main() {
	flag.Parse()

	r := gin.Default()
	r.GET("/dlercloud/v1/relay/list", func(c *gin.Context) {
		params := []string{"uid", "email", "key"}
		queries := make([]string, len(params))
		for i, p := range params {
			q, ok := c.GetQuery(p)
			if !ok {
				c.JSON(400, gin.H{"error": fmt.Sprintf("missing parameter: `%s`", p)})
				return
			}
			queries[i] = q
		}

		dcli, err := dlercloud.NewClient(*dlercloudEndpoint, dlercloud.Auth{
			UID:   queries[0],
			Email: queries[1],
			Key:   queries[2],
		})

		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}

		relays, err := dcli.List(c)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}

		c.JSON(200, gin.H{"relays": relays})
	})

	err := r.Run(*addr)
	if err != nil {
		log.Fatal(err)
	}
}
