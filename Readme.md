## Configuration Files
Two yml configuration files added to the repo.

`default.yml and production.yml`


We will introduce database properties via two defined secret variables.

```
spring.datasource:
  url: ${DB_URL}
  driver-class-name: ${DB_DRIVER}
```

## Pre-requisites

Run the below command to initialise Docker Swarm.

$ `docker swarm init `


## Secret variables
Let's create two secret variables via Docker.

The parameter '-' indicates that you are going to enter the value and Ctrl + d.
The second line is actual value for the secret variable.


$ `docker secret create DB_URL -`

jdbc:h2:mem:camunda;DB_CLOSE_DELAY=1000

Press Ctrl D to save and complete creating secret

$ `docker secret create DB_DRIVER -`

org.h2.Driver

Press Ctrl D to save and complete creating secret

To list the secrets, use this command.

$ `docker secret list`


## New Docker image
Let's create a *new* image using the Camunda base image. 
See Dockerfile for more info.

$ `docker buildx build -t camunda7-22 .`


## Runtime container with Secrets
Create and Run docker service using the new image created in the last step.

This service has access to the two secret variables.

Name of the docker runtime container is **camunda7-22-runtime**.

$ `docker service  create --name camunda7-22-runtime  --restart-max-attempts 1 --replicas 1 --secret DB_URL --secret DB_DRIVER "camunda7-22"`


## Clean up
If you are running this project as a PoC, you may want to remove the docker service. Use below command.

This completes the clean up of runtime container.

$ `docker service rm camunda7-22-runtime`


--------------------
## Other notes

Docker secrets are stored in encrypted form.

https://docs.docker.com/engine/swarm/secrets/#simple-example-use-secrets-in-a-windows-service
