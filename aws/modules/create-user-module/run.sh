#!/bin/bash

terraform apply -auto-approve

USER_ACCESS_KEY=$(terraform output -raw user_access_key)
USER_SECRET_KEY=$(terraform output -raw user_secret_key)

echo "AWS_ACCESS_KEY_ID=$USER_ACCESS_KEY" > credentials
echo "AWS_SECRET_ACCESS_KEY=$USER_SECRET_KEY" >> credentials

chmod 600 ../generated_credentials

echo "Credentials written to 'credentials' file:"
cat ../generated_credentials