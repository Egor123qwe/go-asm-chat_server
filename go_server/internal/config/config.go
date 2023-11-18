package config

import (
	"github.com/spf13/viper"
	"log"
)

type Config struct {
	UDPPort  int
	TCPPort  int
	IP       string
	Protocol string
}

func New() *Config {
	viper.AddConfigPath("internal/config")
	viper.SetConfigName("config")
	if err := viper.ReadInConfig(); err != nil {
		log.Fatal(err)
	}

	return &Config{
		UDPPort:  viper.GetInt("udp_server_port"),
		TCPPort:  viper.GetInt("tcp_server_port"),
		IP:       viper.GetString("ip"),
		Protocol: viper.GetString("protocol"),
	}
}
