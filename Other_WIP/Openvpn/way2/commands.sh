### This works

https://github.com/dockovpn/docker-openvpn

# On server
docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 8088:8080/tcp \
-e HOST_ADDR='rudenspavasaris.id.lv' \
--name dockovpn alekslitvinenk/openvpn

# Local
mkdir ~/vpn
wget http://rudenspavasaris.id.lv:8088/ -O ~/vpn/client.ovpn
sudo openvpn --config ~/vpn/client.ovpn


### TOOD:
- [ ] https://blog.apnic.net/2017/06/09/using-openvpn-ipv6/
