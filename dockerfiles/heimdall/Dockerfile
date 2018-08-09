FROM ruby:2.4.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV RAILS_ROOT /var/www/heimdall

RUN mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

ADD Gemfile Gemfile

RUN gem install bundler && bundle install --jobs 20 --retry 5

# Deploy production server to container
ARG RAILS_ENV=production
ARG RAILS_RELATIVE_URL_ROOT=/heimdall

ADD . .

RUN mv config/mongoid.yml config/mongoid.yml.orig
RUN mv config/mongoid.yml.docker config/mongoid.yml

# precompile is only necessary for production builds
RUN cp config/secrets.example.yml config/secrets.yml
RUN bash -c "RAILS_ENV=$RAILS_ENV RAILS_RELATIVE_URL_ROOT=$RAILS_RELATIVE_URL_ROOT SECRET_KEY_BASE=$(openssl rand -hex 64) bundle exec rake assets:precompile"
RUN rm config/secrets.yml
RUN mkdir -p /srv/secrets/
RUN touch /srv/secrets/secrets.yml
RUN ln -s /srv/secrets/secrets.yml config/secrets.yml 
RUN rm -rfv /srv/secrets

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
