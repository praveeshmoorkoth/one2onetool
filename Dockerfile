# FROM node :Base image for the application(Image for Node.js.)
FROM node

# Define the working directory of Docker container
WORKDIR /apps/one2onetool

# Install app dependencies
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 8082
CMD [ "npm", "start" ]
