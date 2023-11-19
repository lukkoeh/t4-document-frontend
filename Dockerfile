FROM nginx:latest
# install nodejs lts and npm
RUN apt update
RUN apt install -y nodejs npm
# install vue cli
RUN npm install -g @vue/cli
# copy vue app
COPY . /app
WORKDIR /app
# install dependencies
RUN npm install
# build vue app
RUN npm run build
# copy dist/ to /usr/share/nginx/html
RUN cp -r dist/* /usr/share/nginx/html
# expose port 80
EXPOSE 80
# start nginx
CMD ["nginx", "-g", "daemon off;"]