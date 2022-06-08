FROM nginx
COPY promotions-manager-ui.tar.gz /promotions-manager-ui.tar.gz
RUN tar -xvf /promotions-manager-ui.tar.gz -C /usr/share/nginx/html && apt install -y curl
COPY default_config /etc/nginx/sites-available/default
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install -y nodejs