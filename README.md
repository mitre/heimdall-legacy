# Heimdall

Heimdall is a centralized aggregation tool for InSpec evaluations

## Description
Heimdall supports viewing of InSpec profiles and evaluations in a convenient
interface.  Data uploads can be automated through usage of curl, and added as
a step after an InSpec pipeline stage.

## Versioning and State of Development
This project uses the [Semantic Versioning Policy](https://semver.org/).

### Branches
The master branch contains the latest version of the software leading up to a new release.

Other branches contain feature-specific updates.

### Tags
Tags indicate official releases of the project.

Please note 0.x releases are works in progress (WIP) and may change at any time.

## Heimdall vs Heimdall-Lite

There two versions of the MITRE Heimdall Viewer - the full [Heimdall](https://github.com/mitre/heimdall/) and the [Heimdall-Lite](https://github.com/mitre/heimdall-lite/)  version. We produced each to meet different needs and use-cases.

### Features

|  | [Heimdall-Lite](https://github.com/mitre/heimdall-lite/) | [Heimdall](https://github.com/mitre/heimdall/) |
|:--------------------------------------------------------------------------|:--------------|:-------------------------------------|
| Installation Requirements | any web server | rails 5.x Server <br /> MongoDB instance |
| Overview Dashboard & Counts | x | x |
| 800-53 Partition and TreeMap View | x | x |
| Data Table / Control Summary  | x | x |
| InSpec Code / Control Viewer | x | x |
| SSP Content Generator | x | x |
| PDF Report and Print View | x | x |
|  |  |  |
| Users & Roles & multi-team support |  | x |
| Authentication & Authorization | Hosting Webserver | Hosting Webserver<br />LDAP<br />GitHub OAUTH & SAML<br />GitLab OAUTH & SAML |
| Advanced Data / Filters for Reports and Viewing |  | x |
| Multiple Report Output<br />(DISA Checklist XML, CAT, XCCDF-Results, and more) |  | x |
| Authenticated REST API |  | x |
| InSpec Run 'Delta' View |  | x |
| Multi-Report Tagging, Filtering and Compairison |  | x |

### Use Cases

| [Heimdall-Lite](https://github.com/mitre/heimdall-lite/) | [Heimdall](https://github.com/mitre/heimdall/) |
|:------------------------------------|:--------------------------------------------------------|
| Ship the App & Data via simple Email | Multiple Teams Support |
| Minimal Footprint & Deployment Time | Timeline and Report History |
| Local or disconnected Use | Centralized Deployment Model  |
| One-Time Quick Reviews | Need to view the delta between one or more runs |
| Decentralized Deployment  | Need to view subsets of the 800-53 control alignment |
| Minimal A&A Time | Need to produce more complex reports in multiple formats |

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
deployed in production mode. Since this is a Ruby application it is suggested to use
Rbenv or RVM for ruby version management.
1. Install rbenv or RVM
1. Install dependencies
	- `apt-get install build-essential libpq-dev nodejs libxml2-dev libmagick++-dev mongodb-server -y`
1. Install ruby by running `rbenv install` or `rvm install $(cat .ruby-version)` from the root directory of this project
1. Run the following in a terminal
	- `bundle install`
	- `bundle exec rake db:create`
	- `bundle exec rake db:migrate`
	- `bundle exec rails s` (Start the server on localhost)

#### Run With Docker

##### Login Configuration
If you would like to use your organization's internal User authentication
service, when deploying the dockerized Heimdall instance, you'll need to edit
config/ldap.yml to point to your organization's LDAP server. **You do not have
to use your internal LDAP. However, people will have to create an account in
Heimdall to perform most actions** You may view ldap.example.yml for how
authentication of people's internal email addresses works with a LDAP server
which allows anonymous access.

##### Setup Docker Container
These steps need to be performed once per machine in order to prepare your machine to run heimdall in Docker.

1. Install Docker
2. Download heimdall by running `git clone https://github.com/mitre/heimdall.git`.
3. Navigate to the base folder where `docker-compose.yml` is located
4. Run the following commands in a terminal window from the heimdall source directory:
   * `./setup-docker-secrets.sh`
   * `docker-compose up -d`


##### Managing Docker Container
The following commands are useful for managing the data in your docker container:
	* `docker-compose run web rake db:reset` **This destroys and rebuilds the db**
	* `docker-compose run web rake db:migrate` **This updates the db**


##### Running Docker Container
Make sure you have run the setup steps at least once before following these steps!

1. Run the following command in a terminal window:
   * `docker-compose up -d`
2. Go to `127.0.0.1:3000/heimdall` in a web browser

##### Updating Docker Container
A new version of the docker container can be retrieved by running

    docker-compose pull
    docker-compose up -d
    docker-compose run web bundle exec rake db:migrate

This will fetch the latest version of the container, redeploy if a newer version exists, and then apply any database migrations if applicable. No data should be lost by this operation.

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
allow all visitors to view the profile/evaluation you uploaded.**

To upload through curl you'll need an API key. This is located on your profile
page which can be reached by clicking on your user name in the top right
corner, then on profile.

The upload API takes three parameters: the file, your email address, and your API key.

```
curl -F "file=@FILE_PATH" -F email=EMAIL -F api_key=API_KEY http://localhost:3000/evaluation_upload_api
```

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

# Contributing, Issues and Support

## Contributing

Please feel free to look through our issues, make a fork and submit *PRs* and improvements. We love hearing from our end-users and the community and will be happy to engage with you on suggestions, updates, fixes or new capabilities.

## Issues and Support

Please feel free to contact us by **opening an issue** on the issue board, or, at [inspec@mitre.org](mailto:inspec@mitre.org) should you have any suggestions, questions or issues. If you have more general questions about the use of our software or other concerns, please contact us at [opensource@mitre.org](mailto:opensource@mitre.org).

## Licensing and Authors

### Authors
* Robert Thew
* Aaron Lippold
* Matthew Dromazos
* Luke Malinowski

### NOTICE

© 2018 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.

## NOTICE
MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

### NOTICE

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.
