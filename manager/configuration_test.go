package manager

import (
	"fmt"
	"testing"
)

func TestConfiguration(t *testing.T) {
	fmt.Println("TestConfiguration")

	configFile := "../config/config.json"

	conf := LoadConfiguration(configFile)

	if conf == nil {
		t.Error("conf should not be null")
	}
}
