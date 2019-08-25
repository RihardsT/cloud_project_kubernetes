SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013

sudo mkdir /backups
sudo chown rihards:rihards /backups
sudo tar -cf /backups/nextcloud_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_data
sudo tar -cf /backups/nextcloud_postgres_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_postgres
sudo tar -cf /backups/minecraft_$(date +%Y-%m-%d_%H.%M.%S).tar /data/minecraft_data

# Extract
tar -xf nextcloud.tar -C /
tar -xf nextcloud_postgres.tar -C /
tar -xf minecraft.tar -C /


# Copy over
SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013
rm -f /backups/*
sudo tar -cf /backups/nextcloud_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_data
sudo tar -cf /backups/nextcloud_postgres_$(date +%Y-%m-%d_%H.%M.%S).tar /data/nextcloud_postgres
sudo tar -cf /backups/minecraft_$(date +%Y-%m-%d_%H.%M.%S).tar /data/minecraft_data
exit
cd /media/1TB/Other/PC/Hetzner_backups
SERVER_IP="95.216.206.226"; scp -P 3013 ${SERVER_IP}:/backups/* ./
