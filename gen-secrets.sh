#!/bin/bash


if [[ ! -a config/secrets.yml ]]
then
	echo "Generated secrets."
	cat >config/secrets.yml <<EOF 
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

elif [[ $(grep ENV config/secrets.yml) ]]
then
	cat <<-EOF 
		config/secrets.yml exists, but is set to pull vars from the environment.
		Rename it if you you'd like this build script to generate a secrets.yml 
		with random values for keys. Or, if it does not pull from the env...
	EOF
	exit 2
elif [[ $(grep production config/secrets.yml) ]]
then
	echo "Config already exists and has keys for production"

fi

chmod 640 config/secrets.yml
