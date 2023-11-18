package tcp

import (
	"fmt"
	"go-server/internal/app/services"
	"net"
	"strings"
)

type server struct {
	listener net.Listener
}

func New(ip string, port int) (*server, error) {
	address := fmt.Sprintf("%s:%d", ip, port)

	listener, err := net.Listen("tcp", ":1234")
	if err != nil {
		return nil, err
	}
	fmt.Printf("TCP: Serving on %s\n", address)

	return &server{
		listener,
	}, nil
}

func (s *server) Start() error {
	from := "TCP: "
	for {
		conn, err := s.listener.Accept()
		if err != nil {
			fmt.Println(from+"Error accepting connection:", err)
			continue
		}

		fmt.Println(from+"Client connected:", conn.RemoteAddr())

		go handleClient(conn)
	}
}

func handleClient(conn net.Conn) {
	defer conn.Close()
	buffer := make([]byte, 1024)
	from := "TCP: "

	for {
		getBytesCount, err := conn.Read(buffer)
		if err != nil {
			fmt.Println(from+"Read data error:", err)
			break
		}

		msg := strings.TrimRight(string(buffer[:getBytesCount]), "\n")
		fmt.Printf(from+"From: %s | message: %s\n", conn.RemoteAddr(), msg)

		input := services.ReadConsole(from)
		_, err = conn.Write(input)
		if err != nil {
			fmt.Printf(from+"Data send error: %s\n", err.Error())
			break
		}
	}

	fmt.Println("Client connection completed:", conn.RemoteAddr())
}
