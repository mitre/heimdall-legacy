pkg_name=heimdall
pkg_origin=mitre
pkg_version="0.1.0"
pkg_scaffolding="core/scaffolding-ruby"
pkg_binds=( [database]="port" )

pkg_deps=(
  #core/git
  #core/ruby
  #core/bash
  core/imagemagick
)
pkg_build_deps=(
  core/imagemagick
)

#  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
#  cipher_password: <%= ENV['CIPHER_PASSWORD'] %>
#  cipher_salt: <%= ENV['CIPHER_SALT'] %>

export SECRET_KEY_BASE=`openssl rand -hex 64`
export CIPHER_PASSWORD=`openssl rand -hex 64`
export CIPHER_SALT=`openssl rand -hex 32`

# do_build() {
#   attach
#   make
# }

#declare -A scaffolding_env
# Define path to config file
#scaffolding_env[APP_CONFIG]="{{pkg.svc_config_path}}/database.json"
