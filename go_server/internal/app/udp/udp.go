package udp

import (
	"fmt"
	"go-server/internal/app/services"
	"net"
)

type server struct {
	conn *net.UDPConn
}

func New(ip string, port int) (*server, error) {
	address := fmt.Sprintf("%s:%d", ip, port)

	addr, err := net.ResolveUDPAddr("udp", address)
	if err != nil {
		return nil, err
	}

	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		return nil, err
	}

	fmt.Printf("Serving on %s\n", address)

	return &server{
		conn,
	}, nil
}

func (s *server) Start() error {
	buffer := make([]byte, 1024)
	for {
		_, addr, err := s.conn.ReadFromUDP(buffer)
		if err != nil {
			fmt.Printf("Read data error: %s\n", err.Error())
			continue
		}
		fmt.Printf("From: %s | message: %s\n", addr, string(buffer))

		input := services.ReadConsole()
		fmt.Printf("try to send [%s] ...\n", input)
		sendBytesCount, err := s.conn.WriteToUDP(input, addr)
		if err != nil {
			fmt.Printf("Send data error: %s\n", err.Error())
		} else {
			fmt.Printf("Data: [%s] sent successfully\n", input[:sendBytesCount])
		}
	}
}
