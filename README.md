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

## install

```
make mac                # install brew...etc
make install-dev-tools  # install development tools
```

### Pre-requisites

- Install `docker for desktop`
- Execute `brew install golang-migrate sqlc`
- Execute `go install github.com/golang/mock/mockgen@v1.6.0`

### Database Design

- Design DB schema using dbdiagram.io
  - Export the queries from `https://dbdiagram.io/d/63dbb531296d97641d7dfc31`
- Save and share DB diagram within the team
- Generate SQL code to create database in a target database engine i.e. postgres

### Docker and Postgres

- Execute `docker pull postgres:12-alpine` to get the postgres image
- Execute `docker run --name simplebank -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d simple_bank` to run the postgres container
- Execute `docker logs simplebank` to see the logs
- Execute `docker exec -it simplebank psql -U root` to connect to the postgres container and login as `root` user

### DB migration

- Execute `migrate -version` to verify that the `golang-migrate` has been installed
- Execute `migrate create -ext sql -dir db/migration -seq init_schema` to generate migration files
  - `*.up.sql` is used to migrate up to a new version using `migrate up`
  - `*.down.sql` is used to migrate down to an older version using `migrate down`
- Execute `make migrateup` to migrate data upwards to a new version
- Execute `make migratedown` to revert migration to a previous version
- Manage migrations in future with `migration up/down` commands

### DB and Docker Setup for development

- Execute `make postgres` to run postgres container on local docker setup
- Execute `make createdb` to create the `simple_bank` database
- Execute `make migrateup` to setup tables and initial database state
- If required,
  - Execute `make dropdb` to drop database
  - Execute `make migratedown` to migrate or revert database state to a previous version

### Generate CRUD Golang code from SQL

- Execute `make sqlc` to auto generate CRUD functionalities
- Execute `make mock` to generate mock DB
