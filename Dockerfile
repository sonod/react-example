# build environment
FROM node:15.8.0-alpine3.10 as build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

## import dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn

## build app
COPY . ./
RUN yarn build

# run app
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

## start web server
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
