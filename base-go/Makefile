GO           ?= go
CGO_ENABLED  ?= 0
GOMAINMODULE ?= $(shell $(GO) list -m)
GOFMT        ?= $(GO)fmt # need this plain fail
GOLINT 		 ?= $(GO)langci-lint run
GOTEST 		 ?= $(GO) test -v ./...
ifneq ($(shell which gotestsum),)
	GOTEST := gotestsum --format pkgname
endif
ifneq ($(shell which gofumpt),)
	GOFMT := gofumpt -d .
endif

# custom
GOBUILD_FLAGS ?= -a
EXECS	      ?= bake

.PHONY: spin # Get the code into shape
spin: unused lint format test

.PHONY: bench # Run all benchmarks
bench:
	go test -bench=. -benchmem -cpu=2,4 -count=2 ./...

.PHONY: test # Run tests
test:
	@echo ">> running tests"
	@$(GOTEST)

.PHONY: test-watch # Run tests in watch mode
test-watch:
	@echo ">> running tests (watch mode)"
	@$(GOTEST) --watch

.PHONY: lint # Run linter
lint:
	@echo ">> running linter"
	@$(GOLINT)

.PHONY: format # Run formatter but don't edit
format:
	@echo ">> running formatter"
	@$(GOFMT)

.PHONY: unused # Run check for unused packages
unused:
	@echo ">> running check for unused/missing packages"
	$(GO) mod tidy
	@git diff --exit-code -- go.sum go.mod

.PHONY: vendor # Run go mod vendor, adds/removes vendor packages
vendor:
	@echo ">> adds/removes vendored packages based on go.mod"
	$(GO) mod vendor

# For ARM, check https://github.com/goreleaser/goreleaser/issues/36
.PHONY: build # build for amd64 & wasm
build: build_amd64 build_wasm

.PHONY: build_amd64
build_amd64:
	GOARCH=amd64 GOOS=windows $(GO) build $(GOBUILD_FLAGS) -o $(foreach E,$(EXECS), ./cmd/${E}/builds/${E}-amd64-windows $(GOMAINMODULE)/cmd/${E})
	GOARCH=amd64 GOOS=linux $(GO) build $(GOBUILD_FLAGS) -o $(foreach E,$(EXECS), ./cmd/${E}/builds/${E}-amd64-linux $(GOMAINMODULE)/cmd/${E})
	GOARCH=amd64 GOOS=darwin $(GO) build $(GOBUILD_FLAGS) -o $(foreach E,$(EXECS), ./cmd/${E}/builds/${E}-amd64-darwin $(GOMAINMODULE)/cmd/${E})

.PHONY: build_wasm
build_wasm:
	GOARCH=wasm GOOS=js $(GO) build $(GOBUILD_FLAGS) -o $(foreach E,$(EXECS), ./cmd/${E}/builds/${E}-wasm-js $(GOMAINMODULE)/cmd/${E})

.PHONY: build_goreleaser # build a snapshot release
build-goreleaser:
	goreleaser release --snapshot --clean

# Random Info Dumps
.PHONY: list-all-go-files # Lists go files by package
list-all-go-files:
	@eval "go list -f={{.GoFiles}} ./..."

.PHONY: list-all-test-files # Lists test files by package
list-all-test-files:
	@eval "go list -f={{.TestGoFiles}} ./..."

.PHONY: list-platforms # Lists supported arch-platorm by go
list-platforms:
	go tool dist list

include Makefile.common
