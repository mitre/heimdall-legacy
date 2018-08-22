# Use alpine 3.5 as it is the most recent alpine with an old enough imagemagick
FROM alpine:3.5

# sed is build only should be removed at TODO-remove-at-release
RUN apk --no-cache update && apk --no-cache  --update add ruby ruby-irb ruby-json ruby-rake \
    ruby-bigdecimal ruby-io-console libstdc++ tzdata nodejs sed libressl \
	 libxml2 'imagemagick<7.0.0.0'

ENV RAILS_ROOT /var/www/heimdall

RUN mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

# TODO-remove-at-release
COPY inspec-tools/ inspec-tools/

COPY Gemfile Gemfile

# Edit inspec_tools to use a locally downloaded gem
RUN sed -i"" -e 's#.inspec_tools.*:git.*$#"inspec_tools", :path => "./inspec-tools"#g' Gemfile

# Ensure we never install docs
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

# Install and remove build dependencies. Single line implies single layer so
# the final image does not have any of the build dependencies. TODO use
# --deployment once Gemfile.lock has been commited
RUN apk --no-cache --update add --virtual build-dependencies build-base ruby-dev  \
    postgresql-dev libc-dev linux-headers git libxml2-dev 'imagemagick-dev<7.0.0.0' pkgconf && \
    gem install bundler --no-rdoc --no-ri && \
    bundle install --retry 5 --no-cache --jobs 20 --without development test && \
    apk del build-dependencies

# Deploy production server to container
ARG RAILS_ENV=production
ARG RAILS_RELATIVE_URL_ROOT=/heimdall

COPY . .
RUN mv config/mongoid.yml config/mongoid.yml.orig
RUN mv config/mongoid.yml.docker config/mongoid.yml

# Edit inspec_tools to use a locally downloaded gem
RUN sed -i"" -e 's#.inspec_tools.*:git.*$#"inspec_tools", :path => "./inspec-tools"#g' Gemfile

# precompile is only necessary for production builds
RUN cp config/secrets.example.yml config/secrets.yml
RUN sh -c "RAILS_ENV=$RAILS_ENV RAILS_RELATIVE_URL_ROOT=$RAILS_RELATIVE_URL_ROOT SECRET_KEY_BASE=$(openssl rand -hex 64) bundle exec rake assets:precompile"
RUN rm config/secrets.yml

# Setup broken symlink, which fixed at run time by a volume mount
RUN mkdir -p /srv/secrets/
RUN touch /srv/secrets/secrets.yml
RUN ln -s /srv/secrets/secrets.yml config/secrets.yml 
RUN rm -rfv /srv/secrets

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
