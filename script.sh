#!/bin/bash
set -e

echo "gcloud auth"
gcloud auth configure-docker gcr.io --quiet

cd dest
echo "docker build"
docker build -q -t gcr.io/gcp-pso-bfg-playground/target .

# access scope for Storage must be Read Write in order to push to GCR
echo "docker push"
docker push gcr.io/gcp-pso-bfg-playground/target
