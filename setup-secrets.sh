#!/bin/bash

for secret in SECRET_KEY_BASE CIPHER_PASSWORD CIPHER_SALT; do
    echo "Checking $secret"
    if [[ ! $(heimdall config:get $secret) ]]; then
        echo "$secret not found, setting"
        heimdall config:set "$secret"=$(heimdall run rake secret) &2>1 /dev/null
    fi
done
