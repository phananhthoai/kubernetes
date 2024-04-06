#!/usr/bin/env bash
set -e

microk8s helm repo add elastic https://Helm.elastic.co

microk8s helm upgrade --install -n elk-system elastic elastic/elasticsearch --create-namespace -f elastic.yml
microk8s helm upgrade --install -n elk-system kibana elastic/kibana --create-namespace -f kibana.yml
microk8s helm upgrade --install -n elk-system logstash elastic/logstash --create-namespace -f logstash.yml

microk8s helm uninstall -n elk-system kibana --no-hooks
microk8s kubectl delete -n elk-system configmap kibana-kibana-helm-scripts
microk8s kubectl delete -n elk-system secret kibana-kibana-es-token
microk8s kubectl delete -n elk-system roles pre-install-kibana-kibana
microk8s kubectl delete -n elk-system rolebinding pre-install-kibana-kibana
microk8s kubectl delete -n elk-system serviceaccounts pre-install-kibana-kibana
