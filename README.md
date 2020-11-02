# MUST READ: THIS PACKAGE HAS BEEN SUPERSEDED

This repository has been replaced by https://github.com/mitre/heimdall2, please update any links accordingly.

![Docker Pulls](https://img.shields.io/docker/pulls/mitre/heimdall?label=Docker%20Hub%20Pulls)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/mitre/heimdall)
# Heimdall

Heimdall is a centralized visualization server for your InSpec evaluations and profiles.

## Description

Heimdall supports viewing of InSpec profiles and evaluations in a convenient interface. Data uploads can be automated through usage of curl and added as a step after an InSpec pipeline stage.

## Heimdall vs Heimdall-Lite

There two versions of the MITRE Heimdall - the full [Heimdall](https://github.com/mitre/heimdall/) and the [Heimdall-Lite](https://github.com/mitre/heimdall-lite/) version. We produced each to meet different needs and use-cases.

### Use Cases

| [Heimdall-Lite](https://github.com/mitre/heimdall-lite/) | [Heimdall](https://github.com/mitre/heimdall/) |
| :------------------------------------------------------- | :---------------------------------------------------------- |
| Ship the App & Data via simple Email                     | Multiple Teams Support                                      |
| Minimal Footprint & Deployment Time                      | Timeline and Report History                                 |
| Local or disconnected Use                                | Centralized Deployment Model                                |
| One-Time Quick Reviews                                   | Need to view the delta between one or more runs             |
| Decentralized Deployment                                 | Need to view subsets of the 800-53 control alignment        |
| Minimal A&A Time                                         | Need to produce more complex reports in multiple formats    |

### Features

| Features                                                                       | Heimdall-Lite     | Heimdall                                                                      |
| :----------------------------------------------------------------------------- | :---------------- | :---------------------------------------------------------------------------- |
| Installation Requirements                                                      | any web server    | rails 5.x Server <br/> PostgreSQL                                             |
| Overview Dashboard & Counts                                                    | x                 | x                                                                             |
| 800-53 Partition and TreeMap View                                              | x                 | x                                                                             |
| Data Table / Control Summary                                                   | x                 | x                                                                             |
| InSpec Code / Control Viewer                                                   | x                 | x                                                                             |
| SSP Content Generator                                                          | x                 | x                                                                             |
| PDF Report and Print View                                                      | x                 | x                                                                             |
| Users & Roles & multi-team support                                             |                   | x                                                                             |
| Authentication & Authorization                                                 | Hosting Webserver | Hosting Webserver<br />LDAP<br />GitHub OAUTH & SAML<br />GitLab OAUTH & SAML |
| Advanced Data / Filters for Reports and Viewing                                |                   | x                                                                             |
| Multiple Report Output<br />(DISA Checklist XML, CAT, XCCDF-Results, and more) |                   | x                                                                             |
| Authenticated REST API                                                         |                   | x                                                                             |
| InSpec Run 'Delta' View                                                        |                   | x                                                                             |
| Multi-Report Tagging, Filtering and Comparison                                 |                   | x                                                                             |

## Installation

Heimdall supports running via RPM packages, Docker and Chef Habitat(coming soon). For production installations we recommend one of these three methods.

We publish our latest builds on [packackager.io](https://packager.io/gh/mitre/heimdall), [Docker Hub](https://hub.docker.com/r/mitre/heimdall) and Chef Habitat (Coming Soon).

### Run with Vagrant and Virtualbox

You can easily run a local instance for demo and testing purposes using our provided `Vagrantfile` in the project which installs a simple `centos7` VM locally and uses the above RPM method to install, configure and start Heimdall.

1. Install Vagrant
2. Install a Virtualbox or some other Vagrant support VM system
3. Grab our [Vagrantfile](https://github.com/mitre/heimdall/blob/master/Vagrantfile) or just clone the github repository.
4. run `vagrant up` in the directory where you cloned the `heimdall` repo or downloaded the `Vagrantfile`
5. Navigate to `localhost:3000` once the process is complete
6. Create your first account
7. Enjoy

### Run with RPM

To run Heimdall you just need to add the Heimdall [Packager.io](https://dl.packager.io/srv/mitre/heimdall/master/installer/el/7.repo) repository to your Yum configuration and you can easily deploy and update Heimdall on RHEL7/CentOS7 system.

1. `curl -o /etc/yum.repos.d/heimdall.repo https://dl.packager.io/srv/mitre/heimdall/master/installer/el/7.repo`
2. `yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm`
3. `yum update`
4. `yum install -y heimdall`
5. `/usr/pgsql-11/bin/postgresql-11-setup initdb`
6. `echo "local   all             all                                trust" > /var/lib/pgsql/11/data/pg_hba.conf`
7. `systemctl enable postgresql-11`
8. `systemctl start postgresql-11`
9. `sudo -u postgres createuser --superuser heimdall`
10. `heimdall config:set DATABASE_URL=postgresql:///heimdall_production`
11. `heimdall run rake db:create db:schema:load || true`
12. `heimdall run rake db:migrate`
13. `heimdall scale web=1`
14. Navigate to `hostname:6000`
15. Create your first account
16. Enjoy

### Run With Docker

Given that Heimdall requires at least a database service, we use Docker Compose.

#### Setup Docker Container (Clean Install)

1. Install Docker
2. Download heimdall by running `git clone https://github.com/mitre/heimdall.git`.
3. Navigate to the base folder where `docker-compose.yml` is located
4. Run the following commands in a terminal window from the heimdall source directory:
   1. `./setup-docker-secrets.sh`
   2. **Optional:** Set a custom root URL by editing the `docker-compose.yml` and changing `HEIMDALL_RELATIVE_URL_ROOT` to the path of your choosing, for example `/heimdall`.
   3. `docker-compose up -d`
   4. `docker-compose run --rm web rake db:create db:migrate`
6. Navigate to `http://127.0.0.1:3000`

#### Managing Docker Container

The following commands are useful for managing the data in your docker container:

- `docker-compose run --rm web rake db:reset` **This destroys and rebuilds the db**
- `docker-compose run --rm web rake db:migrate` **This updates the db**
- `docker-compose run --rm web rake data:migrate` **This updates the db**

#### Running Docker Container

Make sure you have run the setup steps at least once before following these steps!

1. Run the following command in a terminal window:
   - `docker-compose up -d`
2. Go to `127.0.0.1:3000` in a web browser

##### Updating Docker Container

A new version of the docker container can be retrieved by running:

```
docker-compose pull
docker-compose up -d
docker-compose run web rake db:migrate
docker-compose run web rake data:migrate
```

This will fetch the latest version of the container, redeploy if a newer version exists, and then apply any database migrations if applicable. No data should be lost by this operation.

##### Stopping the Container

`docker-compose down` # From the source directory you started from

### Run with Chef Habitat

(Coming Soon)

### Run from Github

This mode is primarily for developers, shared heimdall instances should be deployed in production mode. Since this is a Ruby application it is suggested to use `rbenv` or `RVM` for ruby version management.

1. Install `rbenv` or `RVM`
2. Install dependencies
   1. `apt-get install -y build-essential libpq-dev nodejs libxml2-dev libmagick++-dev postgresql-server`
3. Install ruby by running `rbenv install` or `rvm install $(cat .ruby-version)` from the root directory of this project
4. Clone the Heimdall Github repository
5. Run the following in a terminal
   1. `bundle install`
   2. `bundle exec rake db:setup`
   3. `bundle exec rake db:migrate`
   4. `bundle exec rails s` (Start the server on localhost)

### Updating from GitHub
1. Pull the latest master from the Heimdall Github repository
2. Run the following in a terminal
  1. `bundle exec rake db:migrate`
  2. `bundle exec rake data:migrate`
  4. `bundle exec rails s` (Start the server on localhost)

## Using Heimdall

### Getting Started

Once you install Heimdall, you will have to create your first account. By default this account will have full `admin` rights and you will then be able to create other users and grant them access to roles, `circles` (groups) and teams as you need. You can add your first user by selecting 'Create Account' and then logging in as that user.

### Using LDAP and OAuth

Heimdall also supports connecting to your corporate LDAP and other OAuth authentication services but the authorization of those users in Heimdall is managed via the application itself (_PRs Welcome_).

### Uploading Results Manually

Once you have an account you can upload InSpec JSONs (see [reporters](https://www.inspec.io/docs/reference/reporters/)) for evaluations and profile then view them by clicking on the evaluations and profiles tab at the top of the page.

### Supporting Groups/Circles and Multiple Teams

Heimdall supports separating users into groups we call 'Circles' which is basically just groups and roles. This will allow you to deploy a command service which many teams can use, allow your AO or Security Teams to review and comment on multiple teams work while still providing separation of roles and responsibilities.

The Heimdall Administrator can define Circles and add users to those circles. At the moment, this is done directly in the Heimdall application (_PRs Welcome_) and teams can `push` their results to a circle via `curl`. This will allow multiple work streams to happen and easy integration into workflow processes while trying to keep the human element from going blind :).

My default everything goes to the public circle, you should define your circles with respect to the R&R of your organization and project and program structure.

Although it's just a suggestion, we have also found that having a few generic results in the `public` circle is useful to help easy demonstrations or conversations to happen. This will allow all visitors to view the profile/evaluation you uploaded.

### Remote Upload and Pipeline Integration via CURL

To upload through curl you'll need an API key. This is located on your profile page which can be reached by clicking on your user name in the top right corner, then on profile.

At its most basic, the upload API takes three parameters: the file, your email address, and your API key.

```
curl -F "file=@FILE_PATH" -F "email=EMAIL" -F "api_key=API_KEY" http://localhost:3000/evaluation_upload_api
```
If you are an owner or member of any circles, you can have the uploaded evaluation added to your circle by supplying a circle name parameter:

```
curl -F "file=@FILE_PATH" -F "email=EMAIL" -F "api_key=API_KEY" -F "circle=CIRCLE NAME" http://localhost:3000/evaluation_upload_api
```

You can also added parameters for Hostname, UUID, FISMA System, and Environment. The first three can by any string, but the environment needs to be one of ['sandbox, 'dev', 'test', 'impl', 'prod']

```
curl -F "file=@FILE_PATH" -F "email=EMAIL" -F "api_key=API_KEY" -F "hostname=HOSTNAME" -F "uuid=UUID" -F "fisma system=FISMA" -F "environment=test" http://localhost:3000/evaluation_upload_api
```

### Useful Tools

The [inspec_tools](https://github.com/mitre/inspec_tools) and [heimdall_tools](https://github.com/mitre/heimdall_tools) also have useful features that help you manage your results, do integration with your CI/CD and DevOps pipelines and get your teams working.

[inspec_tools](https://github.com/mitre/inspec_tools) has the [`compliance`](https://github.com/mitre/inspec_tools#compliance) and [`summary`](https://github.com/mitre/inspec_tools#summary) functions which will help you define a `go/no-go` for your pipeline results and allow you to define your `thin blue line` of success or failure. Incorporating these tools, you can `scan`, `process`, `evaluate` and `upload` your results to allow your various teams and `stages` to define the granularity they need while still following the `spirit` of the overall `DevSecOps` process as a whole.

For example, the [`compliance`](https://github.com/mitre/inspec_tools#compliance) function will let you easily use Jenkins, GitLab/Hub CICD or Drone to have clean pass/fail with an `exit 0` or `exit 1` and allow you to define exactly the `high`, `medium` and `low` and overall `compliance score` that you and your Security Official agreed to in `production` or in `development`.

_NOTE_ You should always test like you are in _production_, that is where you are going to end up after all!!

## Configuration

See docker-compose.yml for container configuration

#### Build container from behind an Intercepting proxy

Contact us for advice, we'll be able to send most people our setup.

#### Host container off relative url

Edit RAILS_RELATIVE_URL_ROOT line from docker-compose.yml

#### Switch container to dev mode

Set RAILS_ENV = to development in docker-compose.yml

## Development

### Dependencies

You can setup a deployment/development environment through bundler or docker.

If you wish to use docker, then the dependencies are:

- Docker
- docker-compose

If you wish to use ruby and are on Ubuntu 16, then the dependencies are:

- Ruby 2.4.4
- build-essentials (your distribution's gcc package)
- Bundler
- libpq-dev
- nodejs
- postgresql

## Versioning and State of Development

This project uses the [Semantic Versioning Policy](https://semver.org/).

# Contributing, Issues and Support

## Contributing

Please feel free to look through our issues, make a fork and submit _PRs_ and improvements. We love hearing from our end-users and the community and will be happy to engage with you on suggestions, updates, fixes or new capabilities.

## Issues and Support

Please feel free to contact us by **opening an issue** on the issue board, or, at [inspec@mitre.org](mailto:inspec@mitre.org) should you have any suggestions, questions or issues. If you have more general questions about the use of our software or other concerns, please contact us at [opensource@mitre.org](mailto:opensource@mitre.org).

## A complete PR should include 7 core elements:

- A signed PR ( aka `git commit -a -s` )
- Code for the new functionality
- Updates to the CLI
- New unit tests for the functionality
- Updates to the docs and examples in `README.md`
- (if needed) Example / Template files
  - Scripts / Scaffolding code for the Example / Template files
- Example Output of the new functionality if it produces an artifact

### Our PR Process

1. open an issue on the main heimdall website noting the issues your PR will address
2. fork the repository
3. checkout your repository
4. cd to the repository
5. git co -b `<your_branch>`
6. bundle install
7. `hack as you will`
8. test via rake
9. ensure unit tests still function and add unit tests for your new feature
10. add new docs to the `README.md`
11. (if needed) create and document any example or templates
12. (if needed) create any supporting scripts
13. update the version and changelog (see below for instructions)

14. Open a PRs on the MITRE heimdall repository

### Versioning and the Changelog

There are rake tasks to help with the [Semantic Versioning Policy](https://semver.org/) and updating the Changelog. The rake tasks use the `rake-version` and `github_changelog_generator` gems.

The `github_changelog_generator` gem requires the use of a access token setup with GitHub. Read the gem's [GitHub page](https://github.com/github-changelog-generator/github-changelog-generator#github-token) for instructions on how to setup this token.

If you have the token setup, you should use this set of steps:
1. run `bundle exec rake change:patch` for bug fixes, or `bundle exec rake change:minor` if you're adding a new feature. This will update the Version number and generate the Changelog.
2. `git add VERSION` and `git add CHANGELOG.md` to add the files to your commit.
3. `git commit -m "commit message"`. If your commit fixes an outstanding issue, put the issue number in the commit message, like "Fixes #34"
4. `git push origin <your_branch>`
5. In GitHub, open a Pull Request on the MITRE heimdall repository

If you don't have a token setup for the `github_changelog_generator`, you can run the rake task `bundle exec rake version:bump:patch` to bump the Version number without modifying the Changelog. Then, in your Pull Request, add a comment requesting the Changelog be updated after merging.

After the Pull Request has been merged, switch back to the `master` branch and pull the merged code. You can run the `bundle exec rake change:tag` to create a release tagged with the new Version number.

# Testing

There are a set of tests developed using `rspec`. Run `rake spec` to run the tests.

## Licensing and Authors

### Authors

- Robert Thew
- Aaron Lippold
- Robert Clark
- Matthew Dromazos
- Luke Malinowski

### NOTICE

© 2018-2019 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.

### NOTICE

MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

### NOTICE

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA 22102-7539, (703) 983-6000.
