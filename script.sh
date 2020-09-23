#!/bin/bash
set -e

echo "hg clone"
hg clone http://mock-hg-mirror/ phpmyadmin
cd phpmyadmin/apache

echo "gcloud auth"
gcloud auth configure-docker gcr.io --quiet

echo "docker build"
docker build -q -t gcr.io/gcp-pso-bfg-playground/phpmyadmin .

# access scope for Storage must be Read Write in order to push to GCR
echo "docker push"
docker push gcr.io/gcp-pso-bfg-playground/phpmyadmin
