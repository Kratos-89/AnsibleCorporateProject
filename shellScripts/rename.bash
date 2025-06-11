#!/bin/bash
instance_ids=$(aws ec2 describe-instances \
  --filters "Name:instance-state-name,Values=running" "Name:tag:Environment,Values=Testing" \
  --query 'Reservations[*].Instance[*].InstanceId' \
  --output text)

mapfile -t sorted_ids < <(echo "$instance_ids" | tr '\t' '\n' | sort)

counter=1
for id in "${sorted_ids[@]}"; do
  name="Instance-$(printf "%02d" $counter)"
  echo "Tagging $id to $name"
  aws ec2 create-tags --resource "$id" \
    --tags Key=Name,Value="$name"
  ((counter++))
done
