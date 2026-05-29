package main

import (
	"context"
	"fmt"
	"html"
	"log"
	"net/http"

	"github.com/redis/go-redis/v9"
)

func main() {
	ctx := context.Background()
	client := redis.NewClient(&redis.Options{
		Addr: "localhost:6379",
		DB:   0})

	result := client.Ping(ctx)
	fmt.Printf("result %v", result)

	err := client.Set(ctx, "fooo", "bar", 0).Err()
	if err != nil {
		panic(err)
	}

	val, err := client.Get(ctx, "foooooo").Result()
	if err != nil {
		panic(err)
	}
	fmt.Println("foo", val)

	http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
