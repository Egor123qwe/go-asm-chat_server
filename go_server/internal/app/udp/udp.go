package udp

import (
	"fmt"
	"go-server/internal/app/services"
	"net"
	"strings"
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

	fmt.Printf("UDP: Serving on %s\n", address)

	return &server{
		conn,
	}, nil
}

func (s *server) Start() error {
	from := "UDP: "
	buffer := make([]byte, 1024)
	for {
		fmt.Println(from + "Waiting for a message...")
		getBytesCount, addr, err := s.conn.ReadFromUDP(buffer)
		if err != nil {
			fmt.Printf(from+"Read data error: %s\n", err.Error())
			continue
		}
		msg := strings.TrimRight(string(buffer[:getBytesCount]), "\n")
		fmt.Printf(from+"From: %s | message: %s\n", addr, msg)

		input := services.ReadConsole(from)
		_, err = s.conn.WriteToUDP(input, addr)
		if err != nil {
			fmt.Printf(from+"Data send error: %s\n", err.Error())
		}
	}
}
