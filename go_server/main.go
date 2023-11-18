package main

import (
	"go-server/internal/app"
	"log"
)

const (
	TCP = "TCP"
	UDP = "UDP"
)

func main() {
	if err := app.New().Start("127.0.0.1"); err != nil {
		log.Fatal(err)
	}
}
