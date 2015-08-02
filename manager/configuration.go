package manager

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
)

// Represents the Server configuration
type Configuration struct {
	DBConnectionString string
}

// Initialize
func LoadConfiguration(configFile string) *Configuration {
	fmt.Println(configFile)
	content, err := ioutil.ReadFile(configFile)
	if err != nil {
		panic(err)
	}
	conf := &Configuration{}
	err = json.Unmarshal(content, &conf)
	if err != nil {
		panic(err)
	}
	fmt.Println(conf)
	return conf

}

/*
   content, err := ioutil.ReadFile("config.json")
    if err!=nil{
        fmt.Print("Error:",err)
    }
    var conf Config
    err=json.Unmarshal(content, &conf)
    if err!=nil{
        fmt.Print("Error:",err)
    }
    fmt.Println(conf)

*/
