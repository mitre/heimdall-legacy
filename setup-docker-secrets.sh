#!/bin/bash

if [ -f .env-prod ]; then
	echo ".env-prod already exists, if you would like to regenerate your secrets, please delete this file and re-run the script."
else
	echo ".env-prod does not exist, creating..."
	cat >.env-prod - << EOF
SECRET_KEY_BASE=$(openssl rand -hex 64)
CIPHER_PASSWORD=$(openssl rand -hex 64)
CIPHER_SALT=$(openssl rand -hex 32)
EOF
fi
echo "Done"
