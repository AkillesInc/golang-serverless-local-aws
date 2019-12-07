## Go-serverless-local-docker

There are a lot of advantages to using serverless AWS lambda functions. But the popular [serverless framework](https://serverless.com/) does not currently support running Go functions locally. To test them you need to deploy and test in the cloud which doesn't provide the quickest feedback loop when developing.

This simple solution uses uses the [AWS Serverless Application Model (AWS SAM)](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html) to run the files locally, you can then still use the serverless framework to deploy your functions to AWS using the simple `sls deploy` command.

Having all these tools (serverless, AWS CLI, AWS SAM, pip3) installed on your machine can be a pain so I've bundled this all in a docker conainter giving you a development environment with everything pre-installed.

As a prerequisite you need to have [docker](https://docs.docker.com/v17.09/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/) installed your local machine. 

#### Build the docker image
```bash
make build
```

#### Run the container
```bash
make dev
```
This will also throw you into the conatiners console.

#### Run the lambda functions locally
```bash
make local
```

One thing to bear in mind is this repo uses the heavy weight golang base image available from Docker Hub.  This contains an entire base OS filesystem along with the an installation of the GoLang tools and packages.  Your Dockerfile copies the .go source code into the container, downloads any dependencies, and does the full build inside the container itself.  This can result in an image hundreds of megabytes large.

The alternative is that you can install the GoLang compiler to your local host computer, and use the local compiler to build the GoLang binary.  Then using either the minimalist scratch image or a purposely small filesystem like Alpine as the base (~5MB), you can copy just your single GoLang binary to the container.  This results in a very small docker image.