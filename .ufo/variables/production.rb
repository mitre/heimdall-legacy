# Example ufo/variables/production.rb
# More info on how variables work: http://ufoships.com/docs/variables/
@environment = helper.env_file(".env-prod")
@cpu = 512
@environment = helper.env_vars(%Q[
  RAILS_ENV=production
  RAILS_SERVE_STATIC_FILES="true"
  HEIMDALL_RELATIVE_URL_ROOT=""
  DISABLE_SPRING="true"
  DATABASE_URL=postgres://postgresql:2WMU7h6G@heimdall-rds.ctp9kse964go.us-east-1.rds.amazonaws.com:5432/heimdall_prod
  SECRET_KEY_BASE=43fadd81616504ac977f1e93b0d2ff00c01e48e2c4c42531d4a078888b5daab1633ca7c3960a1a0c193c18cd0c35d6276d478cdc63575eee82af195ceb261899
  CIPHER_PASSWORD=05c530a0e5567c48158c8b7678c195afdef05601e4ec1110f362d95a08bc17de2b491ebbd856cc6aefe31607a931f71fc1ee7f95244d85d93029b5790b60cced
  CIPHER_SALT=b609b3262ceb7332eee46b3acea0595770ef5d99fb22a0009718f730651040dc
])
