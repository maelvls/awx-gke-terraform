#!/bin/bash

# Prerequisite: GNU sed so that we can use -i (in-place)

# Get kube config
if [ ! -d ~/.kube/configs ]; then
    echo "Creating ~/.kube/configs..."
    mkdir -p ~/.kube/configs
fi

# Get vars from terraform output
echo "Retrieving zone and name from tf output..."
terraform init >/dev/null
ZONE=$(terraform output -json | jq -r .zone.value)
NAME=$(terraform output -json | jq -r .cluster_name.value)

echo "Getting cluster kubeconfig from gcloud..."
gcloud config set project "$NAME" &>/dev/null
rm -f ~/.kube/configs/"$NAME"-gke
KUBECONFIG=~/.kube/configs/"$NAME"-gke gcloud container clusters get-credentials "$NAME" --zone "$ZONE" >/dev/null

# Use sed to do replacement
echo "Changing name of config context..."
CUR_VAL="gke_${NAME}_${ZONE}_${NAME}"
sed -i '' "s/$CUR_VAL/$NAME-gke/g" ~/.kube/configs/"$NAME"-gke

# I use direnv so that I get the secrets auto-loaded on 'cd'.
echo "Setting KUBECONFIG=~/.kube/configs/$NAME-gke in ./.envrc"
awk '!/KUBECONFIG/' .envrc >tmp && mv tmp .envrc
echo "export KUBECONFIG=~/.kube/configs/$NAME-gke" >>.envrc
