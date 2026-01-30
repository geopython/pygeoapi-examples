###################################################################
#
# Authors: Tom Kralidis <tomkralidis@gmail.com>
#
# Copyright (c) 2026 Tom Kralidis
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
###################################################################

PROJECT_NAME=pygeoapi-pubsub-demo

DOCKER_COMPOSE_ARGS=--project-name ${PROJECT_NAME} --file docker-compose.yml --file docker-compose.override.yml

build:
	docker compose $(DOCKER_COMPOSE_ARGS) build

force-build:
	docker compose $(DOCKER_COMPOSE_ARGS) build --no-cache

login:
	docker exec -it pygeoapi-pubsub-demo-api /bin/bash

up:
	docker compose $(DOCKER_COMPOSE_ARGS) up --detach --remove-orphans

upf:
	docker compose $(DOCKER_COMPOSE_ARGS) up --remove-orphans

down:
	docker compose $(DOCKER_COMPOSE_ARGS) down

restart: down up

logs:
	docker compose $(DOCKER_COMPOSE_ARGS) logs --follow

clean:
	docker system prune -f
	docker volume prune -f

rm:
	docker volume rm $(shell docker volume ls --filter name=${PROJECT_NAME} -q)

.PHONY: build up upf login down restart force-build logs rm clean
