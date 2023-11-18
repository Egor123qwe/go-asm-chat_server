package app

import (
	"context"
	"go-server/internal/app/udp"
	"go-server/internal/config"
	"golang.org/x/sync/errgroup"
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

func (s *server) Start(ip string) error {
	gr, _ := errgroup.WithContext(s.ctx)

	gr.Go(func() error {
		udpServer, err := udp.New(ip, s.config.UDPPort)
		if err != nil {
			return err
		}
		return udpServer.Start()
	})
	if err := gr.Wait(); err != nil {
		return err
	}
	return nil
}
