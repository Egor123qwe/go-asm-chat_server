package services

import (
	"bufio"
	"fmt"
	"os"
)

func ReadConsole() []byte {
	reader := bufio.NewScanner(os.Stdin)
	fmt.Print("Enter message: ")
	var input []byte
	if reader.Scan() {
		input = []byte(reader.Text())
	}
	return input
}
