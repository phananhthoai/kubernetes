#!/usr/bin/env bash

set -ex

if [ $(kubectl get services -n greatbunny -o json | jq -r '.items[].metadata.name' | grep -xc greatbunny-nats) == 0 ]; then
  cat values.yaml | yq '.nats' | helm upgrade --install -n greatbunny greatbunny-nats bitnami/nats --version 8.0.6 --atomic -f -
fi

if [ $(kubectl get services -n greatbunny -o json | jq -r '.items[].metadata.name' | grep -xc greatbunny-redis-master) == 0 ]; then
  cat values.yaml | yq '."redis"' | helm upgrade --install -n greatbunny greatbunny-redis bitnami/redis --version 19.3.2  -f -
fi

if [ $(kubectl get services -n greatbunny -o json | jq -r '.items[].metadata.name' | grep -xc greatbunny-postgres-postgresql) == 0 ]; then
  cat values.yaml | yq '.postgres' | helm upgrade --install -n greatbunny greatbunny-postgres bitnami/postgresql --version 15.3.2 --atomic -f -
fi
cat values.yaml | helm upgrade --install -n greatbunny greatbunny ./ -f - --debug ###--atomic
