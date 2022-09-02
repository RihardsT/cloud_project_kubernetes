# TODO:
https://docs.nextcloud.com//server/latest/admin_manual/configuration_server/background_jobs_configuration.html#cron

# I think have this run as cron outside the container - call this from the host
su -s /bin/bash www-data -c 'PHP_MEMORY_LIMIT=512M php -f /var/www/html/cron.php'

News App, RSS - https://github.com/nextcloud/news-updater

#####
echo -n "PASSWORD_GOES_HERE" > .env
# echo -n '"PASSWORD_GOES_HERE"' > .env_nc # Using the same password, but with ""

cd ~/Code/CloudProject/cloud_project_kubernetes/Nextcloud
kubectl create secret generic nextcloud-password --from-file=.env
kubectl apply -f ingress.yml
kubectl apply -f postgres.yml
kubectl apply -f nextcloud.yml
kubectl apply -f collabora.yml
kubectl get all
kubectl logs --follow nextcloud

kubectl get secret nextcloud-password -o yaml

### Cleanup
kubectl delete -f nextcloud.yml
kubectl delete -f postgres.yml
kubectl delete -f collabora.yml
kubectl delete secrets nextcloud-password
SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013 'sudo rm -rf /data/nextcloud_*'

### Collabora
kubectl delete -f collabora.yml
sed -i 's/PASSWORD_GOES_HERE/PASSWORD_GOES_HERE/g' collabora_loolwsd.xml
scp -P 3013 ./collabora_loolwsd.xml rudenspavasaris.id.lv:/home/rihards/loolwsd.xml
SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013 'sudo mkdir /data/collabora_data/; sudo mv /home/rihards/loolwsd.xml /data/collabora_data/loolwsd.xml'

### Trash
https://doks.rudenspavasaris.id.lv/loleaflet/dist/admin/admin.html
sed -i "s/'maintenance' => true/'maintenance' => false/g" config/config.php

### Apps
Calendar
Collabora Online
End-to-end-encryption

# Enable:
Default encryption module

### OCC commands
# in container
su -s /bin/bash www-data PHP_MEMORY_LIMIT=512M ./occ COMMAND
su -s /bin/bash www-data PHP_MEMORY_LIMIT=512M ./occ maintenance:mode --on # --off

######### Postgres upgrade
# Exec into the old versions container and dump
pg_dumpall -U nextcloud > /var/lib/postgresql/data/nextcloud_postgres_11
# Upgrade - update the contaienr version
# Exec into new versions container and restore
psql -U nextcloud -d postgres -f /var/lib/postgresql/data/nextcloud_postgres_11
