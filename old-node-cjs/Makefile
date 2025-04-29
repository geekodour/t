.PHONY: spin # check everything
spin: test build lint format

.PHONY: build # build
build:
	npm run build

.PHONY: test # run tests
test:
	npm run test

.PHONY: test-watch # run tests in watch mode
test-watch:
	npm run test:watch

.PHONY: lint # lint
lint:
	npm run lint

.PHONY: format # format
format:
	npm run format:check

include Makefile.common
