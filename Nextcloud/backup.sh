SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013
ssh 10.17.44.11 -i .ssh/scaleway -p 3013

sudo tar -cvf nextcloud_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_data
sudo tar -cvf nextcloud_postgres_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_postgres

tar -xvf nextcloud.tar -C /
tar -xvf nextcloud_postgres.tar -C /
