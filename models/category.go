package models

// import (
// 	// "github.com/jmoiron/sqlx"
// 	"time"
// )

type Category struct {
	Base
	CategoryId int    // `db:"categoryid"`
	Name       string // `db:"name"`
	// IsDeleted        bool      // `db:"isdeleted"`
	ParentCategoryId *int // `db:"parentcategoryid"`
	// CreatedBy        int       //`db:"createdby"`
	// CreatedDate      time.Time //`db:"createddate"`
	// ModifiedBy       int       //`db:"modifiedby"`
	// ModifiedDate     time.Time //`db:"modifieddate"`
}

type CategoryHistory struct {
	Base
	LogId      int64
	CategoryId int // `db:"categoryid"`
	Operation  string
	Category   *Category
	// CreatedBy    int       //`db:"createdby"`
	// CreatedDate  time.Time //`db:"createddate"`
	// ModifiedBy   int       //`db:"modifiedby"`
	// ModifiedDate time.Time //`db:"modifieddate"`
}

/*
SELECT logid, categoryid, previousstate, operation, createdby, createddate,
       modifiedby, modifieddate
  FROM category_audit_log;


*/
