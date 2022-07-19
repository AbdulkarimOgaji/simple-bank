createpostgres:
	docker run --name postgres14 -p 4000:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_USER=root -d postgres:14-alpine

postgresshell:
	docker exec -it postgres14 psql -U root

init-migrations:
	migrate create -ext sql -dir db/migration -seq init_schema

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:password@localhost:4000/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:password@localhost:4000/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

.PHONY:
	createpostgres, postgresshell, init-migration, createdb, dropdb, migrateup, migratedown, sqlc