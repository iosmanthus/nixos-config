package main

import (
	"flag"
	"log"
	"net/http"

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
		var auth dlercloud.Credential
		if c.BindQuery(&auth) != nil {
			return
		}

		dcli, err := dlercloud.NewClient(*dlercloudEndpoint, auth)
		if err != nil {
			_ = c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		relays, err := dcli.ListRelays(c)
		if err != nil {
			_ = c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.JSON(http.StatusOK, gin.H{"relays": relays})
	})

	r.GET("/dlercloud/v1/relay/source_node/list", func(c *gin.Context) {
		var auth dlercloud.Credential
		if c.BindQuery(&auth) != nil {
			return
		}

		dcli, err := dlercloud.NewClient(*dlercloudEndpoint, auth)
		if err != nil {
			_ = c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		nodes, err := dcli.ListSourceNodes(c)
		if err != nil {
			_ = c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.JSON(http.StatusOK, gin.H{"source_nodes": nodes})
	})

	r.POST("/dlercloud/v1/relay/create", func(c *gin.Context) {
		var auth dlercloud.Credential
		if c.BindQuery(&auth) != nil {
			return
		}

		var createRelay dlercloud.CreateRelay
		if c.BindJSON(&createRelay) != nil {
			return
		}

		dcli, err := dlercloud.NewClient(*dlercloudEndpoint, auth)
		if err != nil {
			_ = c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		err = dcli.CreateRelay(c, &createRelay)
		if err != nil {
			_ = c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.Status(http.StatusOK)
	})

	err := r.Run(*addr)
	if err != nil {
		log.Fatal(err)
	}
}
