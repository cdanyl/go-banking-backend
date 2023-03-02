BREW := $(shell brew --version 2>/dev/null)
GO := $(shell go version 2>/dev/null)

REQUIRED_BINS := brew go migrate sqlc

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: help
all: help

## Setup:
.PHONY: mac
mac: ## Setup project and install deps for mac users
	make check-required-bins
	make install-brew
	make install-go
	make install-deps

.PHONY: check-required-bins
check-required-bins: ## Checking required binaries
	$(foreach bin,$(REQUIRED_BINS),\
        $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))

.PHONY: install-brew
install-brew: ## Checking brew installation
ifdef BREW
	@echo "Found version $(BREW)"
else
	@echo "Brew not found. Installing..."
	$(shell bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
endif

.PHONY: install-go
install-go: ## Checking go installation
ifdef GO
	@echo "Found version $(GO)"
else
	@echo "Go not found. Installing..."
	brew install go
endif

.PHONY: install-deps
install-deps: ## Installing go deps
	brew install golang-migrate
	brew install sqlc

## Docker:
.PHONY: docker-postgres
docker-postgres: ## pull or run postgres docker container
	ssh -p 310 dan@192.168.50.151 exec docker run --name simplebank -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d postgres

## Database:
.PHONY: createdb
createdb: ## Create empty postgres database
	ssh -p 310 dan@192.168.50.151 exec docker exec -t simplebank createdb --username=root --owner=root simple_bank

.PHONY: logdb
logdb: ## Log database
	ssh -p 310 dan@192.168.50.151 exec docker logs simplebank

.PHONY: dropdb
dropdb: ## Drop postgres database
	ssh -p 310 dan@192.168.50.151 exec docker exec -t simplebank dropdb simple_bank

.PHONY: migrateup
migrateup: ## Apply all or N up migrations
	migrate -path db/migration -database "postgres://root:password@192.168.50.151:5433/simple_bank?sslmode=disable" -verbose up

.PHONY: migratedown
migratedown: ## Apply all or N down migrations
	migrate -path db/migration -database "postgres://root:password@192.168.50.151:5433/simple_bank?sslmode=disable" -verbose down

help: ## Show this help
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)