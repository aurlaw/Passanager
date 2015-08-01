package manager

import (
	// "encoding/json" // "github.com/aurlaw/passanager/manager"
	"fmt"
	// "github.com/aurlaw/passanager/models"
	"strconv"
	"testing"
)

var manager *CategoryManager

const (
	DB_HOST     = "192.168.20.100"
	DB_USER     = "passanager"
	DB_PASSWORD = "skwxhStJ"
	DB_NAME     = "passanager"
)

func initTest() {

	dbinfo := fmt.Sprintf("host=%s user=%s password=%s  dbname=%s sslmode=disable",
		DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)

	conf := &Configuration{DBConnStr: dbinfo}
	manager = &CategoryManager{conf}

}

func TestGetAllActive(t *testing.T) {
	fmt.Println("TestGetAllActive")

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
