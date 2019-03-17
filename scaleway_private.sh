SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013
ssh 10.17.44.11 -i .ssh/scaleway -p 3013
sudo openvpn --daemon --config ~/back-xs.ovpn

# First connection
SERVER_IP="163.172.162.100"; ssh ${SERVER_IP} -p 3013
ssh root@10.17.44.11 -i .ssh/scaleway
apt-get install openvpn

POD_NAME=$(kubectl get pods --namespace "openvpn" -l "app=openvpn,release=openvpn" -o jsonpath='{ .items[0].metadata.name }')
SERVICE_IP="163.172.162.100"
KEY_NAME="back-xs"
kubectl --namespace "openvpn" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$SERVICE_IP"
kubectl --namespace "openvpn" exec -it "$POD_NAME" cat "/etc/openvpn/certs/pki/$KEY_NAME.ovpn" > ~/"$KEY_NAME.ovpn"

sed -i 's/163.172.162.100 32085/10.16.152.7 32085/g' ~/back-xs.ovpn
sed -i 's/rudenspavasaris.id.lv/10.16.152.7/g' ~/back-xs.ovpn
scp -P 3013 -i .ssh/scaleway ~/"$KEY_NAME.ovpn" rihards@10.17.44.11:/home/rihards/
scp -P 22 -i .ssh/scaleway ~/"$KEY_NAME.ovpn" rihards@10.17.44.11:/home/rihards/
sudo openvpn --daemon --config ~/back-xs.ovpn

echo "KUBELET_EXTRA_ARGS=--fail-swap-on=false" | sudo tee /etc/default/kubelet
### First run
docker run -ti --rm --net host -v ~/Code/CloudProject/cloud_project_ansible:/d -v ~/Code/CloudProject/Secrets/:/Secrets/ -v ~/.ssh/:/root/.ssh -w /d williamyeh/ansible:alpine3-onbuild sh -c 'apk add --no-cache openssh-client && \
eval "$(ssh-agent -s)"; ssh-add /root/.ssh/scaleway && \
ansible-playbook -i ./Inventory --limit backend -u root --diff Backend.yml -e ansible_port=22'
### Next runs
docker run -ti --rm --net host -v ~/Code/CloudProject/cloud_project_ansible:/d -v ~/Code/CloudProject/Secrets/:/Secrets/ -v ~/.ssh/:/root/.ssh -w /d williamyeh/ansible:alpine3-onbuild sh -c 'apk add --no-cache openssh-client && \
eval "$(ssh-agent -s)"; ssh-add /root/.ssh/scaleway && \
ansible-playbook -i ./Inventory --limit backend -u rihards --diff Backend.yml'



###
scp -P 3013 -i .ssh/scaleway ~/nextcloud* 10.17.44.11:~

scp -P 3013 -i .ssh/scaleway /data/collabora_data/loolwsd.xml 10.17.44.11:~
ssh -p 3013 -i .ssh/scaleway 10.17.44.11 'sudo mkdir /data/collabora_data/; sudo mv ~/loolwsd.xml /data/collabora_data/loolwsd.xml'
