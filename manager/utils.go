package manager

import (
	// "fmt"
	"time"
)

/*
t1, e := time.Parse(
        time.RFC3339,
        "2012-11-01T22:08:41+00:00")

*/
const (
	layout = "2006-01-02T15:04:05"
)

func convertStringToTime(strTime string) (time.Time, error) {
	return time.Parse(layout, strTime)
}
