#!/bin/bash -xe
echo '=============== Staring init script for Promotions Manager API ==============='
touch ${ARTIFACTS_PATH}/api.log
# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

echo '==> apt-get update' >> ${ARTIFACTS_PATH}/api.log
apt-get update -y

echo '==> Instal curl' >> ${ARTIFACTS_PATH}/api.log
apt-get install curl -y

echo '==> Installing node 10' >> ${ARTIFACTS_PATH}/api.log
sudo add-apt-repository -y -r ppa:chris-lea/node.js | sudo tee >> ${ARTIFACTS_PATH}/api.log
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list | sudo tee >> ${ARTIFACTS_PATH}/api.log
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save | sudo tee >> ${ARTIFACTS_PATH}/api.log
echo 'done add-apt-repository' >> ${ARTIFACTS_PATH}/api.log
KEYRING="/usr/share/keyrings/nodesource.gpg"
wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null
gpg --no-default-keyring --keyring "$KEYRING" --list-keys | sudo tee >> ${ARTIFACTS_PATH}/api.log
VERSION=node_10.x
DISTRO="$(lsb_release -s -c)"
echo "deb [signed-by=$KEYRING] http://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src [signed-by=$KEYRING] http://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
sudo apt-get update -y
sudo apt-get install nodejs -y --allow-unauthenticated

echo '==> Installing npm' >> ${ARTIFACTS_PATH}/api.log
sudo apt install libssl1.0-dev -y
sudo apt install nodejs-dev -y
sudo apt install node-gyp -y
sudo apt install npm -y


echo '==> Extract api artifact to /var/promotions-manager-api' >> ${ARTIFACTS_PATH}/api.log
mkdir -p ${ARTIFACTS_PATH}/drop
echo "tar -xvf ${ARTIFACTS_PATH}/promotions-manager-api.*.tar.gz -C ${ARTIFACTS_PATH}/drop/" >> ${ARTIFACTS_PATH}/api.log
tar -xvf ${ARTIFACTS_PATH}/promotions-manager-api.*.tar.gz -C ${ARTIFACTS_PATH}/drop/ >> ${ARTIFACTS_PATH}/api.log 2>&1
mkdir /var/promotions-manager-api/
echo "tar -xvf ${ARTIFACTS_PATH}/drop/drop/promotions-manager-api.*.tar.gz -C /var/promotions-manager-api" >> ${ARTIFACTS_PATH}/api.log
tar -xvf ${ARTIFACTS_PATH}/drop/drop/promotions-manager-api.*.tar.gz -C /var/promotions-manager-api >> ${ARTIFACTS_PATH}/api.log 2>&1

echo '==> Set the DATABASE_HOST env var to be globally available' >> ${ARTIFACTS_PATH}/api.log
DATABASE_HOST=${DATABASE_HOST}.$DOMAIN_NAME
echo 'DATABASE_HOST='${DATABASE_HOST} >> /etc/environment
echo 'RELEASE_NUMBER='${RELEASE_NUMBER} >> /etc/environment
echo 'API_BUILD_NUMBER='{$API_BUILD_NUMBER} >> /etc/environment
echo 'API_PORT='${API_PORT} >> /etc/environment
source /etc/environment

echo '==> Install PM2, it provides an easy way to manage and daemonize nodejs applications' >> ${ARTIFACTS_PATH}/api.log
npm install -g pm2 -y >> ${ARTIFACTS_PATH}/api.log

echo '==> Start our api and configure as a daemon using pm2' >> ${ARTIFACTS_PATH}/api.log
cd /var/promotions-manager-api
pm2 start /var/promotions-manager-api/index.js
pm2 save
chattr +i /root/.pm2/dump.pm2
sudo su -c "env PATH=$PATH:/home/unitech/.nvm/versions/node/v4.3/bin pm2 startup systemd -u root --hp /root" >> ${ARTIFACTS_PATH}/api.log


# tar -xvf /tmp/artifacts/latest/promotions-manager-api.*.tar.gz -C /tmp/artifacts/latest/drop/

# tar -xvf /tmp/artifacts/latest/drop/drop/promotions-manager-api.*.tar.gz -C /var/promotions-manager-api