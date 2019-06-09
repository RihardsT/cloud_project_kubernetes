SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013

sudo tar -cvf nextcloud_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_data
sudo tar -cvf nextcloud_postgres_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_postgres

# Extract
tar -xvf nextcloud.tar -C /
tar -xvf nextcloud_postgres.tar -C /
