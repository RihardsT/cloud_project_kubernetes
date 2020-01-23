# https://github.com/pieterlange/kube-openvpn

##### All run locally
OVPN_SERVER_URL_HERE='rudenspavasaris.id.lv'
OVPN_PORT_HERE=32085

cd ~/Code/Other/kube-openvpn
docker run --user=$(id -u) -e OVPN_SERVER_URL=tcp://${OVPN_SERVER_URL_HERE}:${OVPN_PORT_HERE} -v $PWD:/etc/openvpn:z -ti ptlange/openvpn:0.4.4 ovpn_initpki
# Enter passphrase
CommonName rudenspavasaris.id.lv

docker run --user=$(id -u) -e EASYRSA_CRL_DAYS=180 -v $PWD:/etc/openvpn:z -ti ptlange/openvpn:0.4.4 easyrsa gen-crl
# Enter passphrase

###
cd ~/Code/Other/kube-openvpn
sed -i '/targetPort: 1194/a\    nodePort: 32085' kube/deploy.sh
./kube/deploy.sh default tcp://${OVPN_SERVER_URL_HERE}:${OVPN_PORT_HERE} 10.96.0.0/12 10.244.0.0/16

# Modify deployment.yml to update for Kubernetes 1.17
sed -i 's#extensions/v1beta1#apps/v1#g' kube/deployment.yaml

CLIENTNAME="rihpc"
docker run --user=$(id -u) -v $PWD:/etc/openvpn:z -ti ptlange/openvpn:0.4.4 easyrsa build-client-full $CLIENTNAME nopass
docker run --user=$(id -u) -e OVPN_SERVER_URL=tcp://${OVPN_SERVER_URL_HERE}:${OVPN_PORT_HERE} -v $PWD:/etc/openvpn:z --rm ptlange/openvpn:0.4.4 ovpn_getclient $CLIENTNAME > ~/OpenVPN/$CLIENTNAME.ovpn
sudo openvpn --config ~/OpenVPN/${CLIENTNAME}.ovpn

sudo openvpn --config ~/OpenVPN/example.ovpn
kubectl edit configmap openvpn-ccd
kubectl edit configmap openvpn-portmapping

kubectl apply -f service.yml
python3 -m http.server 20080
### Delete
kubectl delete configmap/openvpn-crl configmap/openvpn-ccd configmap/openvpn-portmapping secret/openvpn-pki configmap/openvpn-settings service/openvpn deployment.apps/openvpn
