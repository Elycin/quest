# Dockerfile which will host our appliaction
# Use LTS version of NodeJS. It is deemed production ready and will continue to recieve security updates for two years.
FROM --platform=linux/amd64 node:lts-slim AS base

# Update the environment, there's a SSL bug, maybe they wanted to test candidates on this?
# Rearc's certificate was issued 12/7/2021, could be newer than the AMI.
RUN apt-get update
RUN apt-get upgrade ca-certificates -y

# Our secret word that we will pass to the application as an environment variable.
ENV PORT 3000
ENV HOST "0.0.0.0"

# Expose TCP port so we can access the server.
EXPOSE 3000

# Create working directory and copy source assets.
WORKDIR /app
COPY . /app

# Install depedency.
RUN npm install

# Production Build Stage.
FROM base as prod
# Entrypoint: Force execution of the webserver, ensure nothing else runs in this step.
ENTRYPOINT ["npm", "start"]


# Development Build Stage.
FROM base AS debug
ENTRYPOINT ["bash"]