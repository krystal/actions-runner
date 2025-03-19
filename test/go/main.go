package main

import (
	"database/sql"
	"errors"
	"fmt"
	"log"
	"os"

	_ "github.com/mattn/go-sqlite3"
	flag "github.com/spf13/pflag"
)

func initDB(dbPath string) (*sql.DB, error) {
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %v", err)
	}

	_, err = db.Exec(
		`CREATE TABLE IF NOT EXISTS kvstore ` +
			`(key TEXT PRIMARY KEY, value TEXT);`,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to create table: %v", err)
	}

	return db, nil
}

func Set(db *sql.DB, key string, value string) error {
	_, err := db.Exec(
		"INSERT OR REPLACE INTO kvstore(key, value) VALUES(?, ?)",
		key,
		value,
	)
	return err
}

func Get(db *sql.DB, key string) (string, error) {
	var value string
	err := db.QueryRow("SELECT value FROM kvstore WHERE key = ?", key).
		Scan(&value)
	return value, err
}

func main() {
	if err := mainE(); err != nil {
		log.Fatalf("Error: %v", err)
	}
}

func mainE() error {
	dbPath := flag.StringP(
		"db", "d", "./kvstore.db", "Path to the database file",
	)

	flag.Parse()

	db, err := initDB(*dbPath)
	if err != nil {
		return err
	}
	defer db.Close()

	switch os.Args[1] {
	case "set":
		if len(os.Args) != 4 {
			return errors.New("expected key and value")
		}
		key, value := os.Args[2], os.Args[3]
		err := Set(db, key, value)
		if err != nil {
			return fmt.Errorf("failed to set value: %v", err)
		}
	case "get":
		if len(os.Args) != 3 {
			return errors.New("expected key")
		}
		key := os.Args[2]
		value, err := Get(db, key)
		if err != nil {
			return fmt.Errorf("failed to get value: %v", err)
		}
		fmt.Println(value)
	default:
		return errors.New("expected 'set' or 'get' command")
	}

	return nil
}
