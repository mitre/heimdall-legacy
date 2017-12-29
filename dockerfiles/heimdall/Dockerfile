FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV RAILS_ROOT /var/www/heimdall

RUN mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

ADD Gemfile Gemfile

RUN gem install bundler && bundle install --jobs 20 --retry 5

ADD . .

RUN mv config/mongoid.yml config/mongoid.yml.orig
RUN mv config/mongoid.yml.docker config/mongoid.yml

CMD ["bundle", "exec", "rails", "server"]

EXPOSE 3000