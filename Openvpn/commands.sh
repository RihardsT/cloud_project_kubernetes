# https://itnext.io/use-helm-to-deploy-openvpn-in-kubernetes-to-access-pods-and-services-217dec344f13

### On master
sudo mkdir -p /data/pv/ovpn
docker build -t ovpn-helm:3.9 .

###
cd ~/Code/CloudProject/cloud_project_kubernetes/Openvpn
kubectl create namespace openvpn
kubectl apply -f pv.yml

# Schedule on master
kubectl taint node back-xs openvpn=back-xs:NoSchedule
kubectl taint node rihpc openvpn=back-xs:NoSchedule
kubectl taint nodes pub-xs master:NoSchedule-
# Schedule on backend
kubectl taint node pub-xs master=pub-xs:NoSchedule
kubectl taint nodes back-xs openvpn:NoSchedule-
kubectl taint nodes rihpc openvpn:NoSchedule-

helm install --name openvpn -f values.yml stable/openvpn --namespace openvpn


kubectl get all --namespace openvpn
POD_NAME=$(kubectl get pods --namespace "openvpn" -l "app=openvpn,release=openvpn" -o jsonpath='{ .items[0].metadata.name }')
SERVICE_IP="rudenspavasaris.id.lv"
KEY_NAME="rihpc"
kubectl --namespace "openvpn" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$SERVICE_IP"
kubectl --namespace "openvpn" exec -it "$POD_NAME" cat "/etc/openvpn/certs/pki/$KEY_NAME.ovpn" > ~/OpenVPN/"$KEY_NAME.ovpn"


sudo openvpn --config ~/OpenVPN/rihpc.ovpn

### Upgrade
helm upgrade openvpn -f values.yml stable/openvpn --namespace openvpn

### Delete
helm del --purge openvpn
