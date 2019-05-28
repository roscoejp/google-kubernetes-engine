#!/usr/bin/env bash

# Build and upload image to GCR
docker build -t jenkins-image .
docker tag jenkins-image gcr.io/vpn-poc-project/jenkins-image:latest
docker push gcr.io/vpn-poc-project/jenkins-image:latest

# Get credentials for private cluster and set Cloud Shell IP to authorized netowrk list
IP="$(dig +short myip.opendns.com @resolver1.opendns.com)/32"
gcloud container clusters update standard-cluster-1 \
    --zone us-east4-a \
    --enable-master-authorized-networks \
    --master-authorized-networks "${IP}"
gcloud container clusters get-credentials standard-cluster-1 --zone us-east4-a --project vpn-poc-project

# Delete pre-existing pods so new image is pulled by cluster
kubectl delete pods -l app=jenkins