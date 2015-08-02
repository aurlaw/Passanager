package manager

import (
	"fmt"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"strconv"
	"testing"
)

var manager *CategoryManager

func initTest() {

	configFile := "../config/config.json"

	conf := LoadConfiguration(configFile)
	// open the db once, no need to close it
	db, err := sqlx.Connect("postgres", conf.DBConnectionString)
	if err != nil {
		panic(err)
	}

	manager = &CategoryManager{db}

}

func TestGetAllActive(t *testing.T) {
	fmt.Println("TestGetAllActive")

	if testing.Short() {
		t.Skip("skipping test short mode")
	}

	initTest()
	catList, err := manager.getActiveCategories()
	// projectList, err := port.GetActiveProjects()
	if err != nil {
		t.Error(err)
	}

	if len(catList) == 0 {
		t.Error("expected category list")
	}

	for _, cat := range catList {
		p := ""
		if cat.ParentCategoryId != nil {
			p = strconv.Itoa(*cat.ParentCategoryId)
		}
		fmt.Printf("Cat: %v (id=%d) pc= %v\n", cat.Name, cat.CategoryId, p)
	}

}

func TestGetCategoryById(t *testing.T) {
	fmt.Println("TestGetCategoryById")
	if testing.Short() {
		t.Skip("skipping test short mode")
	}
	initTest()
	cat, err := manager.getCategoryByID(1)
	if err != nil {
		t.Error(err)
	}

	if cat == nil {
		t.Error("expected category")
	}
	p := ""
	if cat.ParentCategoryId != nil {
		p = strconv.Itoa(*cat.ParentCategoryId)
	}
	fmt.Printf("Cat: %v (id=%d) pc= %v Created: %v \n",
		cat.Name, cat.CategoryId, p, cat.CreatedDate.Format("2006-01-02T15:04:05"))

}

func TestGetCategoryHistoryByID(t *testing.T) {
	fmt.Println("TestGetCategoryHistoryByID")
	if testing.Short() {
		t.Skip("skipping test short mode")
	}
	initTest()
	catList, err := manager.getCategoryHistoryByID(6)

	if err != nil {
		t.Error(err)
	}
	if len(catList) == 0 {
		t.Error("expected category list")
	}
	for _, cat := range catList {
		p := ""
		if cat.Category.ParentCategoryId != nil {
			p = strconv.Itoa(*cat.Category.ParentCategoryId)
		}

		fmt.Printf("History: (id=%d) op: %v PREV: (id=%d) (pcid=%v) cd:%v\n", cat.CategoryId, cat.Operation, cat.Category.CategoryId,
			p, cat.Category.CreatedDate)
	}

}
