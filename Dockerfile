### Use a multi-stage build
# Stage 1: Build stage
### Use a specific base image tag instead of “version:latest”
FROM node:18 AS build
WORKDIR /app
COPY ./app/package*.json ./
RUN npm ci

COPY ./app .

# Stage 2: Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app .
EXPOSE 3000
### Leverage HEALTHCHECK
HEALTHCHECK --interval=10s --timeout=10s --start-period=10s --retries=3 \
    CMD wget http://localhost:3000 --no-verbose --tries=1 --spider || exit 1  

### Run containers as non-root
USER node
CMD ["npm", "start"]
