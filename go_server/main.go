package main

import (
	"go-server/internal/app"
	"log"
)

func main() {
	if err := app.New().Start(); err != nil {
		log.Fatal(err)
	}
}
