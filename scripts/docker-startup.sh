#!/bin/sh
echo -en $KUBE_CRT > /tmp/kube.crt
kubectl config set-cluster uat-cluster --certificate-authority=/tmp/kube.crt --server=$KUBE_API_URL
kubectl config set-credentials uat-user --token=$KUBE_TOKEN
kubectl config set-context uat-context --cluster=uat-cluster --user=uat-user --namespace=laa-apply-for-legalaid-uat
kubectl config use-context uat-context

echo "Migrate Database"
bundle exec rake db:migrate

bundle exec rackup --host 0.0.0.0 -p "4567"
