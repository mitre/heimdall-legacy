# README

## Run With Docker
### Building Docker Containers
_These steps need to be performed the first time you build the docker containers.
You also need to run these commands if you perform any changes to the code base to rebuild the containers._

##### Automated Build Steps
1. Go to the base folder where `docker_build.sh` is located
2. Run the following command:
   1. `./docker_build.sh` (may need to first run `chmod +x docker_build.sh` to give the file executable rights)
3. Jump to [Running Docker Container](#running-docker-container)

##### Manual Build Steps
1. Navigate to base folder where `docker-compose.yml` is located
2. Run the following command in a terminal window:
   1. `docker-compose build`
   2. `docker-compose run web rake db:create`
4. Jump to [Running Docker Container](#running-docker-container)

   
### Running Docker Container
1. Run the following command in a terminal window:
   1. `docker-compose up`
2. Go to `127.0.0.1:3000/heimdall` in a web browser

### Configuration

See docker-compose.yml for container configuration

##### Host container off relative url

Delete RAILS\_RELATIVE\_URL\_ROOT line from docker-compose.yml and dockerfiles/heimdall/Dockerfile

##### Switch container to dev mode

Delete RAILS\_ENV lines from from docker-compose.yml and dockerfiles/heimdall/Dockerfile

#### Get keys

List containers, and take note of the full name of the heimdall\_web image's container. *The container name is the rightmost column NAME.*

``` bash
docker container ps
``` 

Then copy the secrets file out of the container, replace heimdall\_web\_1 with your container's name.

``` bash
docker cp heimdall_web_1:/var/www/heimdall/config/secrets.yml  
```


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
