#!/bin/bash

cd dest

echo "gcloud auth"
gcloud auth configure-docker

echo "docker build"
docker build -t gcr.io/gcp-pso-bfg-playground/target .

echo "docker push"
docker push gcr.io/gcp-pso-bfg-playground/target