# Kubernetes Cloud Builder

Build a Docker image from a Container.

Needs a few things:
* When creating the cluster, the access scope for Storage must be "Read Write" (default is Read Only) so the container can push the built images to GCR.
    * Node Pools -> Security -> Set access for each API
    * https://cloud.google.com/container-registry/docs/access-control#gke
* `docker build` requires access to the docker daemon, so the [deployment](k8s/cloud-builder.yaml) bind mounts the host machine's docker socket
    * https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
    * https://hub.docker.com/_/docker/