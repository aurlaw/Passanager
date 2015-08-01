CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
TAG=${TAG:-latest}

# all: deps build

# deps:
# 	@godep restore

# clean:
# 	@rm -rf Godeps/_workspace controller

run:
	go run src/server.go
build:
	# @godep go build -a -tags 'netgo' -ldflags '-w -linkmode external -extldflags -static' .
	# go build -a -tags 'netgo' -ldflags '-w -linkmode external -extldflags -static' .
	go build -a -installsuffix cgo -o server src/.
# media:
# 	@cd static && bower -s install --allow-root -p | xargs echo

# image: build
# 	@echo Building Go image $(TAG)
# 	sudo docker build -t aurlaw/gotest:$(TAG) .

# container: image
# 	@echo Running Go image $(TAG)
# 	sudo @docker run -it aurlaw/gotest:$(TAG)

# release: deps build image
# 	@docker push shipyard/shipyard:$(TAG)

# test: clean 
# 	@godep go test -v ./...

.PHONY: all deps build clean media image test release

