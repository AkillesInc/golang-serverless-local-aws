## Go-serverless-local-docker

There's a lot of advantages to using serverless AWS lambda functions. But unlike with using [node.js](https://www.npmjs.com/package/serverless-offline) the popular [serverless framework](https://serverless.com/) doesn't currently support running Go functions locally. To test Go lambda functions you have to deploy them to AWS which doesn't really give you the quickest feedback loop when developing.

This simple solution uses uses the [AWS Serverless Application Model (AWS SAM)](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html) inside a docker container to run the files locally. You can then still use the included serverless framework to deploy your functions to AWS when you've finished developing and testing.

Having all these tools (serverless, AWS CLI, AWS SAM, pip3, npm) installed on your machine can be a pain so I've bundled this all in a docker conainter giving you a development environment with everything pre-installed.

As a prerequisite you need to have [docker](https://docs.docker.com/v17.09/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/) installed your local machine. You can then use the commands provided in the Makefile:

#### Build the docker image
```bash
make build
```

#### Run the container and generate go binary
```bash
make dev
```
This will also throw you into the conatiners console. Now you can generate the go binary files
```bash
make go
```

#### Run the lambda functions locally
```bash
make local
```

One thing to bear in mind is this repo uses the heavy weight golang base image available from Docker Hub.  This contains an entire base OS filesystem along with the an installation of the GoLang tools and packages.  Your Dockerfile copies the .go source code into the container, downloads any dependencies, and does the full build inside the container itself.  This can result in an image hundreds of megabytes large.

The alternative is that you can install the GoLang compiler to your local host computer, and use the local compiler to build the GoLang binary.  Then using either the minimalist scratch image or a purposely small filesystem like Alpine as the base (~5MB), you can copy just your single GoLang binary to the container.  This results in a very small docker image.

I'm using the docker evnironment to develop and test Go Lambda function locally and won't be deploying the container, and so the container size isn't an issue for me. 