#!/bin/bash
instance_ids=$(aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" "Name=tag:Environment,Values=Testing" \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text)

# Ensure instance_ids is not empty or whitespace only
instance_ids=$(echo "$instance_ids" | xargs)

sorted_ids=($(echo "$instance_ids" | tr '\t' '\n' | sort))

if [ ${#sorted_ids[@]} -eq 0 ] || [ -z "${sorted_ids[0]}" ]; then
  echo "No running instances found to tag."
  exit 0
fi

counter=1
for id in "${sorted_ids[@]}"; do
  name="Instance-$(printf "%02d" $counter)"
  echo "Tagging $id to $name"
  aws ec2 create-tags --resource "$id" \
    --tags Key=Name,Value="$name"
  ((counter++))
done
