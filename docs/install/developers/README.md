# Installation instructions for developers

Since this is a Ruby application it is suggested to use `rbenv` or `RVM` for ruby version management.

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
