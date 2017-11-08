FROM ruby:2.4.2

ENV http_proxy=http://gatekeeper.mitre.org:80
ENV https_proxy=http://gatekeeper.mitre.org:80
ENV HTTP_PROXY=http://gatekeeper.mitre.org:80
ENV HTTPS_PROXY=http://gatekeeper.mitre.org:80

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV RAILS_ROOT /var/www/heimdall

RUN mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

ADD Gemfile Gemfile

RUN gem install bundler && bundle install --jobs 20 --retry 5

ADD . .

CMD ["bundle", "exec", "rails", "server"]

EXPOSE 3000
