#!/bin/bash

set -xe

# build db and web if needed
docker-compose build
# update db state
docker-compose run web rake db:migrate

