
FROM golang:1.13.3

RUN apt list --installed | grep python

# Install unzip and Python build tools to be able to install the AWS CLI tools.
RUN apt-get update -y && \
  apt-get install -y zip unzip tar curl make git openssh-client python3-pip python3 python-pip

# Setup SSH host verification for github.com (required for go get).
RUN mkdir -p ~/.ssh/ && \
  ssh-keygen -F github.com || ssh-keyscan github.com >>~/.ssh/known_hosts

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
  apt-get install -y nodejs

# Install AWS CLI and AWS SAM CLI
RUN pip3 install --upgrade --no-cache-dir awscli==1.16.266 aws-sam-cli==0.23.0
RUN aws --version
RUN sam --version

# Install docker
RUN VER="18.06.3-ce" && curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz && tar -xz -C /tmp -f /tmp/docker-$VER.tgz && mv /tmp/docker/* /usr/bin

# # Install Dokerize.
RUN DOCKERIZE_VERSION=v0.6.1 && \
  curl -L -o dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
  tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
  rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install Serverless Framework.
RUN npm install -g serverless

# Set default aws region
ENV AWS_DEFAULT_REGION=eu-west-2

# Install Go aws packages
RUN go get github.com/aws/aws-lambda-go/events && go get -u github.com/aws/aws-lambda-go/lambda

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependancies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Check files in container
RUN ls -l
RUN cat Makefile

# Expose port 3000 to the outside world
EXPOSE 3000

CMD /bin/sh
