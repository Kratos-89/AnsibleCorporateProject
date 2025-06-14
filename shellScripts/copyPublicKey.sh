#!/bin/bash
PEM_FILE="client-key.pem"
PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
USER_NAME="ubuntu"
INVENTORY_FILE="./inventory/aws_ec2.yaml"

HOSTS=$(ansible-inventory -i $INVENTORY_FILE --list | jq -r '._meta.hostvars | keys[]')

for HOST in $HOSTS; do
  echo "Injecting public key into $HOST"
  ssh -o StrictHostKeyChecking=no -i $PEM_FILE $USER_NAME@$HOST "
  mkdir -p ~/.ssh && \
  echo \"$PUB_KEY\" >> ~/.ssh/authorized_keys && \
  chmod 700 ~/.ssh &&
  chmod 600 ~/.ssh/authorized_keys
  "
done
