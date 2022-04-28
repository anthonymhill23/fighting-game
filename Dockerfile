# Stage 1 - Install
ARG NODE_ENV=production
ARG NODE_VERSION=16.5.0
ARG npm_config_loglevel=silent

FROM node:${NODE_VERSION} as base
ARG NODE_ENV
ARG npm_config_loglevel
ENV NODE_ENV=$NODE_ENV
ENV npm_config_loglevel=$npm_config_loglevel
ENV NODE_PATH=src
USER node
WORKDIR /usr/src/app
COPY . .
RUN npm install

# Stage 2 - Build
FROM install as build
RUN npm run build 

# Stage 2 - Production
FROM base
COPY --from=build --chown=node:node /usr/src/app/build .
USER node
CMD ["npx", "serve", "-s", "-l", "3000"]