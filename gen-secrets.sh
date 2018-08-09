#!/bin/bash

[[ "$@" =~ "-h" ]] && cat <<EOF
$0 [[ --overwrite]]

$0 generates a named volume of heimdall_heimdall_secrets which contains random
keys and other initial secrets. The secrets file is left in the config/
directory for ease of use.

	--overwrite : Will overwrite an existing set of secrets in the named volume
EOF

[[ "$@" =~ "-h" ]] && exit 0

# Exit if volume exists
docker inspect heimdall_heimdall_secrets >/dev/null 2>/dev/null \
	&& [[ $1 != --overwrite ]] \
	&& echo -e "Volume which may hold keys exists. Run '$0 --overwrite' to force generation 
of new keys. This will break any existing Heimdall database containing users." 1>&2 \
	&& exit 0
docker volume create heimdall_heimdall_secrets
docker run -v heimdall_heimdall_secrets:/srv/secrets --name heim_helper busybox true

if [[ ! -a config/secrets.yml ]]
then
	echo "Generating secrets."
	touch config/secrets.yml && chmod 700 config/secrets.yml
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

echo Copying secrets into named volume.
docker cp config/secrets.yml heim_helper:/srv/secrets/
