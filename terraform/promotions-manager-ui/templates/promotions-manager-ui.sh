#!/bin/bash -x

touch ${ARTIFACTS_PATH}/ui.log
echo '=============== Staring init script for Promotions Manager UI ==============='

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt
echo '==> Installing Node.js and NPM' >> ${ARTIFACTS_PATH}/ui.log
apt-get update
apt install curl -y
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install nodejs

echo '==> Install nginx' >> ${ARTIFACTS_PATH}/ui.log
apt-get install nginx -y

echo '==> Extract ui artifact to /var/www/promotions-manager/' >> ${ARTIFACTS_PATH}/ui.log
mkdir -p ${ARTIFACTS_PATH}/drop
echo "tar -xvf ${ARTIFACTS_PATH}/promotions-manager-ui.*.tar.gz -C ${ARTIFACTS_PATH}/drop/" >> ${ARTIFACTS_PATH}/ui.log
tar -xvf ${ARTIFACTS_PATH}/promotions-manager-ui.*.tar.gz -C ${ARTIFACTS_PATH}/drop/ >> ${ARTIFACTS_PATH}/ui.log 2>&1
mkdir /var/www/promotions-manager/
echo "tar -xvf ${ARTIFACTS_PATH}/drop/drop/promotions-manager-ui.*.tar.gz -C /var/www/promotions-manager/" >> ${ARTIFACTS_PATH}/ui.log
tar -xvf ${ARTIFACTS_PATH}/drop/drop/promotions-manager-ui.*.tar.gz -C /var/www/promotions-manager/ >> ${ARTIFACTS_PATH}/ui.log 2>&1

echo '==> Configure nginx' >> ${ARTIFACTS_PATH}/ui.log
cd /etc/nginx/sites-available/
cp default default.backup
# proxy_pass http://promotions-manager-api.$DOMAIN_NAME:${API_PORT}/api;
cat << EOF > ./default
server {
	listen ${PORT} default_server;
	listen [::]:${PORT} default_server;
	root /var/www/promotions-manager;
	server_name _;
	index index.html index.htm;
	location /api {		
		proxy_pass http://${API_HOST}:${API_PORT}/api;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection 'upgrade';
		proxy_set_header Host \$host;
		proxy_cache_bypass \$http_upgrade;
		proxy_read_timeout 600s;
	}
	location / {
		try_files \$uri /index.html;
	}
}
EOF

echo 'Start nginx service' >> ${ARTIFACTS_PATH}/ui.log
service nginx stop >> ${ARTIFACTS_PATH}/ui.log
service nginx start >> ${ARTIFACTS_PATH}/ui.log

echo "ui config done" >> ${ARTIFACTS_PATH}/ui.log