BREW := $(shell brew --version 2>/dev/null)
GO := $(shell go version 2>/dev/null)

REQUIRED_BINS := brew go golang-migrate sqlc

.PHONY: check-required-bins
check-required-bins:
	@echo "Checking required binaries..."
	$(foreach bin,$(REQUIRED_BINS),\
        $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))

.PHONY: mac
mac:
	make check-required-bins
	make install-brew

.PHONY: install-dev-tools
install-dev-tools:
	make check-required-bins
	make install-go

.PHONY: install-go
install-go:
	@echo "Checking go..."
ifdef GO
	@echo "Found version $(GO)"
else
	@echo Go not found. Installing...
	brew install go
endif
	# dependencies
	@echo Installing Go dependencies...
	brew install golang-migrate
	brew install sqlc

.PHONY: install-brew
install-brew:
	@echo "Checking brew..."
ifdef BREW
	@echo "Found version $(BREW)"
else
	@echo Brew not found. Installing...
	$(shell bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
endif

.PHONY: postgres
postgres:
	docker run --name simplebank -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d simple_bank

.PHONY: createdb
createdb:
	docker exec -it simplebank createdb --username=root --owner=root simple_bank

.PHONY: dropdb
dropdb:
	docker exec -it simplebank dropdb simple_bank

.PHONY: migrateup
migrateup:
	migrate -path db/migration -database "postgres://root:password@192.168.50.151:5433/simple_bank?sslmode=disable" -verbose up

.PHONY: migratedown
migratedown:
	migrate -path db/migration -database "postgres://root:password@192.168.50.151:5433/simple_bank?sslmode=disable" -verbose down
