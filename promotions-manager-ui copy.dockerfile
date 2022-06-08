
# FROM hoosin/alpine-nginx-nodejs:latest

# COPY promotions-manager-ui.tar.gz /promotions-manager-ui.tar.gz

# ENV SRC_DIR ./node_modules ./public ./src
# ENV NGINX_STATIC /usr/share/nginx/html/
# ENV NGINX_CONF /etc/nginx/


# RUN node -v \
#     && npm -v \
#     && yarn -v \
#     && yarn config set registry https://registry.npm.taobao.org \
#     && yarn config get registry \
#     && yarn install --verbose \
#     && yarn build

# RUN tar -xvf /promotions-manager-ui.tar.gz -C $NGINX_STATIC
# COPY default_config /etc/nginx/sites-available/default
# EXPOSE 80
# RUN nginx -t

# CMD ["nginx","-g","daemon off;"]





FROM debian
RUN apt-get update && apt-get install -y \
	curl \
	python \
	make \
	g++
# RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get update && apt-get install -y \
	nodejs
COPY promotions-manager-ui.tar.gz /promotions-manager-ui.tar.gz
RUN tar -xvf /promotions-manager-ui.tar.gz -C /var/www/api
COPY ./src /var/www/api
RUN cd /var/www/api; npm install
EXPOSE 3000
CMD ["node", "/var/www/api/service-worker.js"]


FROM nginx
COPY promotions-manager-ui.tar.gz /promotions-manager-ui.tar.gz
RUN tar -xvf /promotions-manager-ui.tar.gz -C /usr/share/nginx/html
COPY default_config /etc/nginx/sites-available/default
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install -y nodejs