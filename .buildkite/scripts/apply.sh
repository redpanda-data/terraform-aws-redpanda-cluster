#!/bin/bash

AWS_ACCESS_KEY_ID=$DA_AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$DA_AWS_SECRET_ACCESS_KEY

mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -C "test@redpanda.com" -N "" -f ~/.ssh/id_rsa <<< y && chmod 0700 ~/.ssh/id_rsa

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --TF_DIR) TF_DIR="$2"; shift ;;
        --PREFIX) PREFIX="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if TF_DIR and PREFIX are set
if [ -z "$TF_DIR" ] || [ -z "$PREFIX" ]; then
    echo "TF_DIR and PREFIX must be set. Exiting."
    exit 1
fi

cd "$TF_DIR" || exit 1
terraform init || exit 1

# Trap to handle terraform destroy on exit
trap cleanup EXIT INT TERM
cleanup() {
    error_code=$?
    terraform destroy --auto-approve
    exit $error_code
}

terraform apply -var "deployment_prefix=$PREFIX" --auto-approve

# Trap will handle destroy so just exit
exit $?