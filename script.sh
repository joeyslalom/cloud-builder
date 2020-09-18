#!/bin/bash
set -e

echo "gcloud auth"
gcloud auth configure-docker gcr.io

#cd dest
#echo "docker build"
#docker build -q -t gcr.io/gcp-pso-bfg-playground/target .

# access scope for Storage must be Read Write in order to push to GCR
#echo "docker push"
#docker push gcr.io/gcp-pso-bfg-playground/target

git clone https://github.com/phpmyadmin/docker.git
cd docker
docker build -q -t gcr.io/gcp-pso-bfg-playground/pma apache
docker push gcr.io/gcp-pso-bfg-playground/pma