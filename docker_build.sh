#!/bin/bash

set -xe

docker-compose build
docker-compose run web rake db:create