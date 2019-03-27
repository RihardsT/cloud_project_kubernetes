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
