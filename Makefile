REPO:=martkcz/php-alpine
VERSION:=8.1.3-r1
PHP:=81

all: build release

build:
	docker build --build-arg "PHP=${PHP}" -t $(REPO):${VERSION} .

release:
	docker push $(REPO):${VERSION}

test:
	sh tests/run.sh "${REPO}:${VERSION}"
