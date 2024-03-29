SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013

sudo mkdir /backups
sudo chown rihards:rihards /backups
rm -f /backups/*
echo $(date +%Y-%m-%d_%H.%M.%S) > /backups/backup_timestamp
sudo tar -czf /backups/nextcloud_$(cat /backups/backup_timestamp).tar /data/nextcloud_data
sudo tar -czf /backups/nextcloud_postgres_$(cat /backups/backup_timestamp).tar /data/nextcloud_postgres
sudo tar -czf /backups/minecraft_$(cat /backups/backup_timestamp).tar /data/minecraft_data

# Extract
cd /backups/
sudo tar -xzf "nextcloud_$(cat /backups/backup_timestamp).tar" -C /
sudo tar -xzf "nextcloud_postgres_$(cat /backups/backup_timestamp).tar" -C /
sudo tar -xzf "minecraft_$(cat /backups/backup_timestamp).tar" -C /


# Copy over
SERVER_IP="95.216.206.226"; ssh ${SERVER_IP} -p 3013
rm -f /backups/*
echo $(date +%Y-%m-%d_%H.%M.%S) > /backups/backup_timestamp
sudo tar -czf /backups/nextcloud_$(cat /backups/backup_timestamp).tar /data/nextcloud_data
sudo tar -czf /backups/nextcloud_postgres_$(cat /backups/backup_timestamp).tar /data/nextcloud_postgres
sudo tar -czf /backups/minecraft_$(cat /backups/backup_timestamp).tar /data/minecraft_data
exit
cd /media/1TB/Other/PC/Hetzner_backups
SERVER_IP="95.216.206.226"; scp -P 3013 ${SERVER_IP}:/backups/* ./



### Using Scaleway Object Storage
# Using s3cmd
https://www.scaleway.com/en/docs/object-storage-with-s3cmd/
pip3 install --user s3cmd

echo "
[default]
host_base = s3.fr-par.scw.cloud
host_bucket = rudenspavasaris.s3.fr-par.scw.cloud
bucket_location = fr-par
use_https = True

# Login credentials
access_key = ACCESS_KEY_HERE
secret_key = SECRET_KEY_HERE
" > ~/.s3cfg

s3cmd ls s3://rudenspavasaris
s3cmd la
s3cmd put nextcloud_$(cat /backups/backup_timestamp).tar nextcloud_postgres_$(cat /backups/backup_timestamp).tar minecraft_$(cat /backups/backup_timestamp).tar s3://rudenspavasaris
s3cmd get nextcloud_$(cat /backups/backup_timestamp).tar nextcloud_postgres_$(cat /backups/backup_timestamp).tar minecraft_$(cat /backups/backup_timestamp).tar

### Full backup
# Nextcloud
rm -f /backups/*
echo $(date +%Y-%m-%d_%H.%M.%S) > /backups/backup_timestamp
sudo tar -czf /backups/nextcloud_$(cat /backups/backup_timestamp).tar /data/nextcloud_data
sudo tar -czf /backups/nextcloud_postgres_$(cat /backups/backup_timestamp).tar /data/nextcloud_postgres_14

cd /backups
s3cmd put nextcloud_$(cat /backups/backup_timestamp).tar nextcloud_postgres_$(cat /backups/backup_timestamp).tar s3://rudenspavasaris

# Minecraft
echo $(date +%Y-%m-%d_%H.%M.%S) > /backups/backup_timestamp
sudo tar -czf /backups/minecraft_$(cat /backups/backup_timestamp).tar /data/minecraft_data
s3cmd put /backups/minecraft_$(cat /backups/backup_timestamp).tar s3://rudenspavasaris

# On the separate server
ssh -o "StrictHostKeyChecking=no" $(terraform output -state=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/terraform.tfstate minecraft | grep -oP '"\K[^"]+')

ssh -o "StrictHostKeyChecking=no" $(terraform output -state=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/terraform.tfstate minecraft | grep -oP '"\K[^"]+') sh -c '/data/minecraft_backup.sh'


###### Backup to Nextcloud
curl -T FILE http://vieta.rudenspavasaris.id.lv/remote.php/dav/files/rihards/FILE
