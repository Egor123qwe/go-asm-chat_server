package main

import (
	"go-server/internal/app"
	"log"
)

// TODO: DockerFile, readME

func main() {
	if err := app.New().Start(); err != nil {
		log.Fatal(err)
	}
}
