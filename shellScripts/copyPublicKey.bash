#!/bin/bash
# Define vars
PEM_FILE="client-key.pem"
PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
USER="ubuntu"
INVENTORY_FILE="./AnsibleCorporateProject/inventory/aws.yaml"

HOSTS=$(ansible-inventory -i $INVENTORY_FILE | jq -r '._meta.hostvars | keys[]')

for HOST in $HOSTS; do
  echo "Injecting public key into $HOST"
  ssh -o strictHostKeyChecking=no -i $PEM_FILE $USER@$HOST "
  mkdir -p ~/.ssh && \
  echo \"$PUB_KEY\" >> ~/.ssh/authorized_keys && \
  chmod 700 ~/.ssh &&
  chmod 600 ~/.ssh/authorized_keys
  "
done
