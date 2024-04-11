package main

import (
	"path/filepath"
	"testing"
)

func TestSetAndGet(t *testing.T) {
	dbPath := filepath.Join(t.TempDir(), "test.db")

	db, err := initDB(dbPath)
	if err != nil {
		t.Fatalf("Failed to initialize database: %v", err)
	}
	defer db.Close()

	key := "testKey"
	value := "testValue"

	err = Set(db, key, value)
	if err != nil {
		t.Fatalf("Failed to set value: %v", err)
	}

	gotValue, err := Get(db, key)
	if err != nil {
		t.Fatalf("Failed to get value: %v", err)
	}

	if gotValue != value {
		t.Fatalf("Expected %s, got %s", value, gotValue)
	}
}
