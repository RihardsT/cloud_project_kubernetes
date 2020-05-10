## Kubernetes for one
I wanted to set up a couple of online and learn a bit of Kubernetes a long the way.
Didn't want to use managed Kubernetes from any of the major cloud providers.
Interesting way to waste resources on, especially for what I've managed to set up.

## Stories
1. I want a calendar
2. I want to be able to edit documents online

## Implementation
Using smallest and cheapest servers I could find: START1-XS Scaleway.
Basically Kubernetes is set with kubeadm: single master node with public ip,
Traefik as load balancer/proxy for services and openvpn server,
also running on master, to enable access to internet for the backend node.
Backend node running Nextcloud and Collabora services, that I care about.

## Pain points
- I'm bad with words
- Quite slow - the small nodes can't cope with the load created by Collabora
- Kubernetes upgrades are full of fun.

## Still to do
- Site to site openvpn connection, to be able to add RaspberryPi worker at home
- Ideally multiple master nodes, for HA
- [ ] https://www.scaleway.com/en/docs/install-and-configure-nextcloud-object-storage/
