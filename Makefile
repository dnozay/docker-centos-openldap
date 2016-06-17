NAME = dnozay/centos-slapd
VERSION = latest
TEST_CONTAINER = test

.PHONY: all build build-nocache

all: build bash

build:
	docker build -t $(NAME):$(VERSION) --rm .

build-nocache:
	docker build -t $(NAME):$(VERSION) --no-cache --rm .

bash:
	docker run -i -t --name $(TEST_CONTAINER) --rm $(NAME):$(VERSION) -v $(PWD)/etc/openldap:/etc/openldap -v $(PWD)/var/lib/ldap:/var/lib/ldap  -p 389:389 /bin/bash

