# Instructions for deployers

If you would like to get started now with no hassle, click [here](http://xk3r.hatchboxapp.com/).

To run Heimdall locally, you have a couple options;

## Installation

To install Heimdall, open up command line and type each of these commands:

> curl -o /etc/yum.repos.d/heimdall.repo https://dl.packager.io/srv/mitre/heimdall/master/installer/el/7.repo

> yum install -y heimdall

> systemctl start mongod systemctl enable mongod

> heimdall scale web=1

## Dependencies

You can setup a deployment/development environment through bundler or docker.

If you wish to use docker, then the dependencies are:

- Docker
- docker-compose (installable with pip)

If you wish to use ruby and are on Ubuntu 16, then the dependencies are:

- Ruby 2.4.4
- build-essentials (your distribution's gcc package)
- Bundler
- libpq-dev
- nodejs
- mongodb

Heimdall supports running via RPM packages, Docker and Chef Habitat(coming soon). For production installations we recommend one of these three methods.

We publish our latest builds on packackager.io, Docker Hub and Chef Habitat (Coming Soon).

## Run with Vagrant and Virtualbox

You can easily run a local instance for demo and testing purposes using our provided Vagrantfile in the project which installs a simple centos7 VM locally and uses the above RPM method to install, configure and start Heimdall.

1. Install Vagrant
2. Install a Virtualbox or some other Vagrant support VM system
3. Grab our Vagrantfile or just clone the github repository.
4. run vagrant up in the directory where you cloned the heimdall repo or downloaded the Vagrantfile
5. Navigate to localhost:3000 once the process is complete
6. Create your first account
7. Enjoy

## Run with RPM

To run Heimdall you just need to add the Heimdall Packager.io repository to your Yum configuration and you can easily deploy and update Heimdall on RHEL7/CentOS7 system.

1. curl -o /etc/yum.repos.d/heimdall.repo https://dl.packager.io/srv/mitre/heimdall_activerecord/master/installer/el/7.repo
2. yum update
3. yum install -y heimdall-activerecord
4. postgresql-setup initdb
5. echo "local all postgres trust" > /var/lib/pgsql/data/pg_hba.conf
6. systemctl enable postgresql
7. systemctl start postgresql
8. heimdall-activerecord run rake db:create db:schema:load || true
9. heimdall-activerecord run rake db:migrate
10. heimdall-activerecord scale web=1
11. Navigate to hostname:6000
12. Create your first account
13. Enjoy

## Run With Docker

Given that Heimdall requires at least a database service, we use Docker Compose.

### Setup Docker Container

1. Install Docker
2. Download heimdall by running git clone https://github.com/mitre/heimdall_activerecord.git.
3. Navigate to the base folder where docker-compose.yml is located
4. Run the following commands in a terminal window from the heimdall source directory:

> ./setup-docker-secrets.sh
> docker-compose up -d

### Managing Docker Container

The following commands are useful for managing the data in your docker container:

- docker-compose run web rake db:reset This destroys and rebuilds the db
- docker-compose run web rake db:migrate This updates the db

### Running Docker Container

Make sure you have run the setup steps at least once before following these steps!

1. Run the following command in a terminal window:
   docker-compose up -d
2. Go to 127.0.0.1:3000/heimdall in a web browser

#### Updating Docker Container

A new version of the docker container can be retrieved by running:

> docker-compose pull
> docker-compose up -d
> docker-compose run web bundle exec rake db:migrate

This will fetch the latest version of the container, redeploy if a newer version exists, and then apply any database migrations if applicable. No data should be lost by this operation.

#### Stopping the Container

> docker-compose down

From the source directory you started from
