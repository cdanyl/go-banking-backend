# Banking Backend (GoLang Version)

### Features

- Create and manage account
  - Owner
  - Balance
  - Currency
- Record all balance changes for each account
  - Create an account entry for each change for each account
- Money transfer transaction
  - Perform money transfer between 2 accounts consistently within a transaction

## Install

### Pre-requisites

- Install `docker for desktop`

> I am using docker through ssh. You can remove ssh part in the Makefile if you want use your Docker desktop

> This project use this binaries: `brew`, `go`, `go-migrate`, `sqlc`

- Execute `make check-required-bins` to check the required binaries need for this project
- Execute `make mac` for mac user to install all deps automatically

```
make help               # Show all commands
```

## DB and Docker Setup for development

- Execute `make docker-postgres` to get and configure a ready postgres docker container
- Execute `make createdb` to create the `simple_bank` database
- Execute `make logdb` to see database logs
- Execute `make migrateup` to setup tables and initial database state
- If required,
  - Execute `make dropdb` to drop database
  - Execute `make migratedown` to migrate or revert database state to a previous version


Check others commands using `make help`

### Database

### Database Design

- Design DB schema using dbdiagram.io
  - Export the queries from `https://dbdiagram.io/d/63dbb531296d97641d7dfc31`
- Save and share DB diagram within the team
- Generate SQL code to create database in a target database engine i.e. postgres

### DB migration

- Execute `migrate -version` to verify that the `golang-migrate` has been installed
- Execute `migrate create -ext sql -dir db/migration -seq init_schema` to generate migration files
  - `*.up.sql` is used to migrate up to a new version using `migrate up`
  - `*.down.sql` is used to migrate down to an older version using `migrate down`
- Execute `make migrateup` to migrate data upwards to a new version
- Execute `make migratedown` to revert migration to a previous version
- Manage migrations in future with `migration up/down` commands

## Generate CRUD Golang code from SQL

- Execute `make sqlc` to auto generate CRUD functionalities
- Execute `make mock` to generate mock DB

## Unit Tests

### Pre-requisites
- `pq` A pure Go postgres driver for Go's database/sql package
- `Testify` Thou Shalt Write Tests

Execute `make test`
