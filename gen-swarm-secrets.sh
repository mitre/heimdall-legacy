#!/bin/bash

# Exit if secret already exists
docker secret inspect heimdall_secrets >/dev/null 2>/dev/null && [[ $1 != --overwrite ]] && exit 0

echo Generating Secrets
docker secret create heimdall_secrets - << EOF
development:
  secret_key_base: d26decda541d849368ddc0655d5fd63bfb246935443eedb1ab2fb15762161f6da3ad665aeed166bfd86b6f43ce87f62fabad9523ea5e6a0b29dbd49d6aba7502
  cipher_password: 'cipher_password'
  cipher_salt: 'cipher_salt'

test:
  secret_key_base: c432c2a7954794eaa017fc50f68a1877d7bffa761f26c2b2cf50a43f40f5f387d933bd51bc91d4e33fcee02cc6728a698bfcd6b276c132739435282e08ef87c7
  cipher_password: 'cipher_password'
  cipher_salt: 'cipher_salt'

# Do not keep production secrets in the unencrypted secrets file.
# Instead, either read values from the environment.
# Or, use \`bin/rails secrets:setup\` to configure encrypted secrets
# and move the \`production:\` environment over there.

production:
  secret_key_base: `openssl rand -hex 64`
  cipher_password: `openssl rand -hex 64`
  cipher_salt: `openssl rand -hex 32`
EOF
