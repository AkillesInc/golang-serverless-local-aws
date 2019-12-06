IMAGE_NAME = goapp-0.1

.PHONY: build clean deploy gomodgen

build:
	docker build -t $(IMAGE_NAME) .

dev:
	docker-compose run --service-ports --rm api

go: gomodgen
	export GO111MODULE=on
	env GOOS=linux go build -ldflags="-s -w" -o bin/hello hello/main.go
	env GOOS=linux go build -ldflags="-s -w" -o bin/world world/main.go

clean:
	rm -rf ./bin ./vendor Gopkg.lock

deploy: clean build
	sls deploy --verbose

gomodgen:
	chmod u+x gomod.sh
	./gomod.sh

local:
	sam local start-api