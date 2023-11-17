# Digikala DevOps hiring task1


This is a simple Node.js web application and containerizing of it.

## Table of Contents

- <a href="#requirements">Requirements</a>
- <a href="#usage">Usage</a>
- <a href="#refrences">Refrences</a>

---
## Requirements

- Docker
- Curl

---
## Usage
You need to clone the project, then build the Docker image:

```bash
$ docker build -t digikala-node-app .
```

and then run the docker container:

```bash
$ docker run -d --name digikala-node-app -p 3000:3000 digikala-node-app:latest
```

You can even check the status of the container with `$ docker ps`. Now, your simple Node.js web application should be running in a Docker container and accessible at http://localhost:3000. Each container will display a message with its unique worker ID which is the container.

---
## Refrences:

https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/

https://www.docker.com/blog/9-tips-for-containerizing-your-node-js-application/

---
Shamim Shahraeini - linkedin.com/in/shamimshahraeini