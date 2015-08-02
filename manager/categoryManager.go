package manager

import (
	"encoding/json"
	// "fmt"
	"github.com/aurlaw/passanager/models"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"time"
)

type CategoryManager struct {
	DB *sqlx.DB
}

// returns all active categories
func (c *CategoryManager) getActiveCategories() ([]models.Category, error) {
	query := `SELECT categoryid, name, isdeleted, parentcategoryid, createdby, createddate, modifiedby, modifieddate 
		FROM category WHERE isdeleted = false`

	catList := []models.Category{}
	err := c.DB.Select(&catList, query)

	return catList, err
}

// get category by id
func (c *CategoryManager) getCategoryByID(categoryId int) (*models.Category, error) {
	query := `SELECT categoryid, name, isdeleted, parentcategoryid, createdby, createddate, modifiedby, modifieddate 
		FROM category WHERE  categoryid = $1`

	cat := &models.Category{}
	err := c.DB.Get(cat, query, categoryId)

	return cat, err
}

// get category history for category
func (c *CategoryManager) getCategoryHistoryByID(categoryId int) ([]models.CategoryHistory, error) {
	query := `SELECT logid, categoryid, previousstate, operation, createdby, createddate,
       modifiedby, modifieddate 
       FROM category_audit_log WHERE  categoryid = $1 ORDER BY modifieddate DESC`
	catList := make([]models.CategoryHistory, 0)
	rows, err := c.DB.Queryx(query, categoryId)
	defer rows.Close()

	for rows.Next() {
		var (
			LogId         int64
			CategoryId    int // `db:"categoryid"`
			Operation     string
			PreviousState string
			CreatedBy     int       //`db:"createdby"`
			CreatedDate   time.Time //`db:"createddate"`
			ModifiedBy    int       //`db:"modifiedby"`
			ModifiedDate  time.Time //`db:"modifieddate"`
		)
		err = rows.Scan(&LogId, &CategoryId, &PreviousState, &Operation, &CreatedBy, &CreatedDate,
			&ModifiedBy, &ModifiedDate)
		if err != nil {
			return catList, err
		}
		cat := new(models.Category)
		// NOTE: We do this manually since parsing json dates w/o timezones causes issues with json obj
		var dat map[string]interface{}
		byt := []byte(PreviousState)
		if err := json.Unmarshal(byt, &dat); err != nil {
			return catList, err
		}
		cat.CategoryId = int(dat["categoryid"].(float64))
		cat.Name = dat["name"].(string)
		cat.IsDeleted = dat["isdeleted"].(bool)
		cat.CreatedBy = int(dat["createdby"].(float64))
		cat.ModifiedBy = int(dat["modifiedby"].(float64))
		cat.CreatedDate = CreatedDate
		cat.ModifiedDate = ModifiedDate
		// nullible fiels
		pcid := dat["parentcategoryid"]
		// fmt.Printf("%v\n", pcid)
		if pcid != nil {
			i := new(int)
			*i = int(pcid.(float64))
			cat.ParentCategoryId = i
		}
		// cd := dat["createddate"]
		// md := dat["modifieddate"]
		// if cd != nil {
		// 	t, terr := convertStringToTime(cd.(string))
		// 	if terr != nil {
		// 		return catList, terr
		// 	}
		// 	cat.CreatedDate = t
		// }
		// if md != nil {
		// 	t, terr := convertStringToTime(md.(string))
		// 	if terr != nil {
		// 		return catList, terr
		// 	}
		// 	cat.ModifiedDate = t

		// }

		// hist := models.CategoryHistory{LogId, CategoryId, Operation, cat, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate}
		hist := models.CategoryHistory{
			LogId:      LogId,
			CategoryId: CategoryId,
			Operation:  Operation,
			Category:   cat,
			Base: models.Base{
				CreatedBy:    CreatedBy,
				CreatedDate:  CreatedDate,
				ModifiedBy:   ModifiedBy,
				ModifiedDate: ModifiedDate,
			},
		}
		catList = append(catList, hist)
	}
	return catList, err
}

// create
// update
// delete
