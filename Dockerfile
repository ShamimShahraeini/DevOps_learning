# Stage 1: Build stage
FROM node:18 AS build
WORKDIR /app
COPY ./app/package*.json ./
RUN npm install
COPY ./app .

# Stage 2: Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app .
EXPOSE 3000
CMD ["npm", "start"]
