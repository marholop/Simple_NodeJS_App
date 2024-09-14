# Using an official Node.js image as our base image
FROM node:14

# Set my working directory in the container
WORKDIR /app

# Copying package.json and package-lock.json to the container
COPY package*.json ./

# Installing dependencies
RUN npm install

# Copy the rest of the application codes to the container
COPY . .

# Expose the app on port 3000
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
