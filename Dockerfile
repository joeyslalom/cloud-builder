FROM ubuntu:20.04
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    gnupg-agent \
    software-properties-common
# https://docs.docker.com/engine/install/ubuntu/
# https://github.com/GoogleCloudPlatform/cloud-builders/blob/master/docker/Dockerfile-19.03.8
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
# https://cloud.google.com/sdk/docs/install#deb
# https://hub.docker.com/r/google/cloud-sdk/dockerfile
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add -

RUN apt-get update -y && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    google-cloud-sdk

COPY script.sh ./

COPY dest/ ./dest

CMD ["sh"]