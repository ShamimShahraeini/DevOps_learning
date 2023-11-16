### Use a multi-stage build
# Stage 1: Build stage
### Use a specific base image tag instead of “version:latest”
FROM node:18 AS build
WORKDIR /app
COPY ./app/package*.json ./
#RUN npm install
RUN npm ci

COPY ./app .

# Stage 2: Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app .
EXPOSE 3000

### Leverage HEALTHCHECK
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1  
CMD ["npm", "start"]
