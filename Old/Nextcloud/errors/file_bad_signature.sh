
# Extract file from backup
tar -xvf nextcloud_2019-02-10_14.42.30.tar data/nextcloud_data/data/rihards/files/Fit_2019.ods -C ./
tar -xvf nextcloud_2019-02-10_14.42.30.tar data/nextcloud_data/data/rihards/files_encryption/keys/files/Fit_2019.ods -C ./

# Move the bad files
mkdir /home/rihards/bad_backup
sudo mv /data/nextcloud_data/data/rihards/files_encryption/keys/files/Fit_2019.ods /home/rihards/bad_backup

# Move backup key
sudo mv data/nextcloud_data/data/rihards/files_encryption/keys/files/Fit_2019.ods /data/nextcloud_data/data/rihards/files_encryption/keys/files/Fit_2019.ods

sudo ls -lah /data/nextcloud_data/data/rihards/files_encryption/keys/files/Fit_2019.ods
sudo chown -R www-data:www-data /data/nextcloud_data/data/rihards/
