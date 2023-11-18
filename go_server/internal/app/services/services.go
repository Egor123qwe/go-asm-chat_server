package services

import (
	"bufio"
	"fmt"
	"os"
)

func ReadConsole(from string) []byte {
	reader := bufio.NewScanner(os.Stdin)
	fmt.Print(from + "Enter message: ")
	var input []byte
	if reader.Scan() {
		input = []byte(reader.Text())
	}
	return input
}
