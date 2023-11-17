# Digikala_DevOps_hiring_task1


This is a simple Node.js web application and containerizing of it.
You need to clone the project, then build the Docker image:

`$ docker build -t digikala-node-app .`

and then run the docker container:

`$ docker run -d --name digikala-node-app -p 3000:3000 digikala-node-app:latest`

You can even check the status of the container with `$ docker ps`. Now, your simple Node.js web application should be running in a Docker container and accessible at http://localhost:3000. Each container will display a message with its unique worker ID which is the container.

