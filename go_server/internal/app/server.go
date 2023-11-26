package app

import (
	"context"
	"errors"
	"go-server/internal/app/tcp"
	"go-server/internal/app/udp"
	"go-server/internal/config"
	"golang.org/x/sync/errgroup"
	"strings"
)

type server struct {
	config *config.Config
	ctx    context.Context
}

func New() *server {
	ctx := context.Background()

	return &server{
		config: config.New(),
		ctx:    ctx,
	}
}

func (s *server) Start() error {
	gr, _ := errgroup.WithContext(s.ctx)

	udpServer, err := udp.New(s.config.IP, s.config.UDPPort)
	if err != nil {
		return err
	}
	tcpServer, err := tcp.New(s.config.IP, s.config.TCPPort)
	if err != nil {
		return err
	}

	if strings.ToLower(s.config.Protocol) == "udp" {
		gr.Go(func() error {
			return udpServer.Start()
		})
	} else if strings.ToLower(s.config.Protocol) == "tcp" {
		gr.Go(func() error {
			return tcpServer.Start()
		})
	} else {
		return errors.New("invalid protocol. See your config file")
	}

	if err := gr.Wait(); err != nil {
		return err
	}
	return nil
}
