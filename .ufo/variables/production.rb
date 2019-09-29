# Example ufo/variables/production.rb
# More info on how variables work: http://ufoships.com/docs/variables/
@cpu = 512
@environment += helper.env_vars(%Q[
  RAILS_ENV=production
  RAILS_SERVE_STATIC_FILES="true"
  HEIMDALL_RELATIVE_URL_ROOT=""
  DISABLE_SPRING="true"
])
