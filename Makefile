REPO:=martkcz/php-alpine
VERSION:=8.0.13

all: build release

build:
	docker build -t $(REPO):${VERSION} .

release:
	docker push $(REPO):${VERSION}
