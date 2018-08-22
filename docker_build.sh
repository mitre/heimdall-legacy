#!/bin/bash

set -xe

# build db and web if needed
docker-compose build

# Attempt db setup
docker-compose run web bundle exec rake db:create >/dev/null 2>/dev/null
docker-compose run web bundle exec rake db:setup >/dev/null 2>/dev/null 
docker-compose run web bundle exec rake db:seed
# update db state
docker-compose run web bundle exec rake db:migrate

