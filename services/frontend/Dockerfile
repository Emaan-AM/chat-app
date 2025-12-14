# frontend Dockerfile
# pull official base image
FROM node:18-alpine

# set working directory
WORKDIR /usr/src/chat-app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/chat-app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json .
COPY package-lock.json .
RUN npm ci
RUN npm install react-scripts@5.0.1 -g --silent

# Copy source files
COPY public/ ./public/
COPY src/ ./src/

# Expose port
EXPOSE 3000

# start app
CMD ["npm", "start"]