REPO:=martkcz/php-alpine
VERSION:=8.1.4-r1

all: build release

build:
	docker build -t $(REPO):${VERSION} .

release:
	docker push $(REPO):${VERSION}
