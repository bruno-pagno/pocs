package main

import (
	"database/sql"
	"fmt"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"net/http"
)

const (
	host     = "host.docker.internal"
	port     = 5432
	user     = "postgres"
	password = "postgres"
	dbname   = "postgres"
)

type dog struct {
	ID    string `json:"id"`
	Breed string `json:"breed"`
}

var dogs = []dog{
	{ID: "1", Breed: "Bulldog"},
	{ID: "2", Breed: "Poodle"},
	{ID: "3", Breed: "Basset"},
	{ID: "3", Breed: "Labrador Retriever"},
	{ID: "3", Breed: "Golden Retriever"},
}

func main() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		panic(err)
	}
	fmt.Println("Connected to the database")
	
	router := gin.Default()
	router.GET("/dogs", get)
	router.GET("/dogs/:id", getById)
	router.POST("/dogs", post)

	router.Run(":8080")
}

func get(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, dogs)
}

func post(c *gin.Context) {
	var newDog dog

	if err := c.BindJSON(&newDog); err != nil {
		return
	}

	dogs = append(dogs, newDog)
	c.IndentedJSON(http.StatusCreated, newDog)
}

func getById(c *gin.Context) {
	id := c.Param("id")

	for _, a := range dogs {
		if a.ID == id {
			c.IndentedJSON(http.StatusOK, a)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "dog not found"})
}
