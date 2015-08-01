package models

import (
	"time"
)

type Base struct {
	IsDeleted    bool      // `db:"isdeleted"`
	CreatedBy    int       //`db:"createdby"`
	CreatedDate  time.Time //`db:"createddate"`
	ModifiedBy   int       //`db:"modifiedby"`
	ModifiedDate time.Time //`db:"modifieddate"`
}
