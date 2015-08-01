package models

import (
	// "fmt"
	"time"
)

type JsonTime struct {
	time.Time
}

var format = "2006-01-02T15:04:05.999999-07:00"

func (t *JsonTime) MarshalJSON() ([]byte, error) {
	return []byte(t.Time.Format(format)), nil
}

func (t *JsonTime) UnmarshalJSON(b []byte) (err error) {
	b = b[1 : len(b)-1]
	t.Time, err = time.Parse(format, string(b))
	return
}
