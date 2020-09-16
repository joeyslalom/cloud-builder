# https://cloud.google.com/run/docs/quickstarts/build-and-deploy?authuser=1#shell
# Use the offical golang image to create a binary.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang:1.15-buster as builder

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies.
# This allows the container build to reuse cached dependencies.
# Expecting to copy go.mod and if present go.sum.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY invoke.go ./

# Build the binary.
RUN go build -mod=readonly -v -o server

# Add docker to google/cloud-sdk
# https://hub.docker.com/r/google/cloud-sdk
# https://docs.docker.com/engine/install/debian/
# https://github.com/GoogleCloudPlatform/cloud-builders/blob/master/docker/Dockerfile-19.03.8
FROM google/cloud-sdk:310.0.0

# need to remove docker in google/cloud-sdk
RUN rm /usr/local/bin/docker && \
    apt-get -y update && \
    apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get -y update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /app/server
COPY script.sh ./
COPY dest/ ./dest/

# Run the web service on container startup.
CMD ["/app/server"]
