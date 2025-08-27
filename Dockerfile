FROM jenkins/jenkins:lts

USER root

# install docker cli
RUN apt-get -y update; apt-get install -y sudo; apt-get install -y git wget
RUN echo "Jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN wget http://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
RUN tar -xvzf docker-latest.tgz
RUN mv docker/* /usr/bin/

# Use an official alpine nodeJS image as the base image
FROM node:alpine

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install only production nodeJS dependencies in Docker Image
RUN npm install --only=production

# Copy the rest of the application code into the container
COPY . .

# Expose the app on a port
EXPOSE 3000

# Command that runs the app
CMD ["npm", "start"]