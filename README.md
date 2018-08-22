# Heimdall

Heimdall is a centralized aggregation tool for InSpec evaluations

## Description
Heimdall supports viewing of InSpec profiles and evaluations in a convenient
interface.  Data uploads can be automated through usage of curl, and added as
a step after an inspec pipeline stage. 

## Installation 
### Dependencies
You can setup a deployment/development environment through bundler or docker.

If you wish to use docker, then the dependencies are:
  * Docker
  * docker-compose (installable with pip)

If you wish to use ruby and are on Ubuntu 16, then the dependencies are:
  * Ruby 2.4.4
  * build-essentials (your distribution's gcc package)
  * Bundler
  * libpq-dev 
  * nodejs
  * mongodb

#### Run directly with Ruby (Instead of Docker)

This mode is primarily for developers, shared heimdall instances should be
deployed in production mode.
1. Install dependencies
	- `apt-get install build-essential libpq-dev nodejs libxml2-dev libmagick++-dev mongodb-server -y`
2. Install ruby 2.4.4
3. Run the following in a terminal
	- `bundle install`
	- `bundle exec rake db:create` 
	- `bundle exec rake db:migrate`
	- `bundle exec rails s` (Start the server on localhost)

#### Run With Docker
##### Building Docker Containers
_These steps need to be performed the first time you build the docker
containers, and whenever you edit the code base._

##### Login Configuration
If you would like to use your organization's internal User authentication
service, when deploying the dockerized Heimdall instance, you'll need to edit
config/ldap.yml to point to your organization's LDAP server. **You do not have
to use your internal LDAP. However, people will have to create an account in
Heimdall to perform most actions** You may view ldap.example.yml for how
authentication of people's internal email addresses works with a LDAP server
which allows anonymous access.


#### Automated Build Steps
1. Run the following commands from a terminal:
	1. `git clone https://github.com/aaronlippold/heimdall.git && cd heimdall` # download heimdall and change to it's directory
	2. `./gen-secrets.sh ` # (Generate Random keys to be stored in a named Docker volume **Do not run if you've ever run it before**)
  3. `./docker_build.sh` # (may need to first run `chmod +x docker_build.sh` to give the file executable rights)
2. Jump to [Running Docker Container](#running-docker-container)

##### Manual Build Steps
1. Install Docker
2. Clone this repository
	* `git clone https://github.com/aaronlippold/heimdall.git`
3. Navigate to the base folder where `docker-compose.yml` is located
4. Run the following command in a terminal window from the heimdall source directory:
   * `git clone https://github.com/aaronlippold/inspec-tools.git`  
5. Run the following command in a terminal window from the heimdall source directory:
   * `docker-compose build`  
6. Generate keys for secrets.yml. Use secrets.example.yml for a template.
	_Internally we generate it with the shell script `./gen-secrets.sh` Which
	creates a named volume which is symlinked to config/secrets.yml at runtime.
	If you are deploying this container to a docker swarm please use docker
	secrets as it is far more secure than a named volume._
7. Run one of the following commands in a terminal window from the heimdall source directory:
	* `docker-compose run web rake db:reset` **This destroys and rebuilds the db**
	* `docker-compose run web rake db:migrate` **This updates the db**
8. Jump to [Running Docker Container](#running-docker-container)

   
##### Running Docker Container
Once you have the container you can run it with:

1. Run the following command in a terminal window:
   * `docker-compose up -d`
2. Go to `127.0.0.1:3000/heimdall` in a web browser

###### Stopping the Container
`docker-compose down` # From the source directory you started from

## Usage

You can access a Demo instance if you have access to the company's intranet at
https://inspec-dev.mitre.org

You can login via the company LDAP server, or by creating a new account.

Once you have an account you can upload jsons for evaluations and profiles
then view them by clicking on the evaluations and profiles tab at the top of
the page.

**When uploading data you may go to the circles tab, and select public. This will
allow all vistors to view the profile/evaluation you uploaded.**

To upload through curl you'll need an API key. This is located on your profile
page which can be reached by clicking on your user name in the top right
corner, then on profile.

## Configuration

See docker-compose.yml for container configuration

#### Build container from behind an Intercepting proxy

Contact us for advice, we'll be able to send most people our setup.

#### Host container off relative url

Edit RAILS\_RELATIVE\_URL\_ROOT line from docker-compose.yml

#### Switch container to dev mode

Set RAILS\_ENV = to development in docker-compose.yml

## Development

Clone, edit, then please submit a PR with an issue number associated.

## Licensing and Authors

### Authors
	* Robert Thew
	* Aaron Lippold
	* Matthew Dromazos
	* Luke Malinowski

### License
	* This project is dual-licensed under the terms of the Apache license 2.0 (apache-2.0)
	* This project is dual-licensed under the terms of the Creative Commons Attribution Share Alike 4.0 (cc-by-sa-4.0)
