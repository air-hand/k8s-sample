#!/usr/bin/env bash

SECRET_NAME=secret-sample-cmd

cd $(dirname $0)
kubectl delete secret/$SECRET_NAME
# kubectl create secret generic NAME [--from-literal=key=value] [--from-file=filename]
kubectl create secret generic $SECRET_NAME \
    --from-literal=sec-literal='From literal' \
    --from-file=./keyfile
kubectl get secret/$SECRET_NAME -o yaml
