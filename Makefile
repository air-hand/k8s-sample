BUILD_TARGET=prod

IS_IN_CONTAINER := $(shell sh -c 'test -f /.dockerenv && echo 0 || echo 1')

.PHONY: vm-init
vm-init: vm-plugin-install
	vagrant up --no-provision \
	&& vagrant vbguest \
	&& vagrant reload --no-provision \
	&& vagrant provision \
	;

.PHONY: vm-destroy
vm-destroy: vm-plugin-install
	vagrant destroy -f \
	;

.PHONY: vm-plugin-install
vm-plugin-install:
	vagrant plugin expunge --local --force; vagrant plugin install --local;

.PHONY: vm-rebuild
vm-rebuild: vm-destroy vm-init

#.PHONY: all
#all: build
#
#.PHONY: build
#build:
#	if [ $(IS_IN_CONTAINER) -eq 0 ]; then \
#		cd src; \
#		find ./ -name "go.mod" | xargs -I{} readlink -e {} | xargs -I{} dirname {} | \
#		xargs -I{} sh -c "cd {}; go mod tidy -compat=1.17; go generate;"; \
#		go build -o /go/bin/app; \
#	elif [ "$(BUILD_TARGET)" = "builder" ]; then \
#		docker compose -f docker-compose.yml -f .devcontainer/docker-compose.dev.yml build; \
#	else \
#		docker compose build; \
#	fi;
#
#.PHONY: up
#up: build
#	if [ $(IS_IN_CONTAINER) -eq 0 ]; then \
#		/go/bin/app; \
#	else \
#		BUILD_TARGET=$(BUILD_TARGET) docker compose up; \
#	fi;
#
#.PHONY: test
#test:
#	if [ $(IS_IN_CONTAINER) -eq 1 ]; then \
#		echo "test should be run in container."; \
#		return; \
#	fi; \
#	find ./src -name "*test*.go" | xargs -I{} dirname {} |\
#	sort -u | shuf |\
#	xargs -I{} readlink -e {} |\
#	xargs -I{} sh -c "cd {}; go test -test.v -shuffle on -cover"; \
#
#.PHONY: shell
#shell: export BUILD_TARGET=builder
#shell: build
#	docker compose run --rm web /bin/bash;
#
#.PHONY: stop
#stop:
#	BUILD_TARGET=$(BUILD_TARGET) docker compose stop;
#
#.PHONY: clean
#clean: stop
#	BUILD_TARGET=$(BUILD_TARGET) docker compose down;
#
#.PHONY: fullclean
#fullclean: stop
#	BUILD_TARGET=$(BUILD_TARGET) docker compose down --volumes --remove-orphans;
