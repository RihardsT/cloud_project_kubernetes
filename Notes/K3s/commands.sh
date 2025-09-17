# https://k3s.io/
# https://docs.k3s.io/quick-start

# Install control-plane node
curl -sfL https://get.k3s.io | sh -  # This will also allow pods to run on main node
curl -fL https://get.k3s.io | sh -s - server # I guess this should allow pods to run on main node
sudo k3s kubectl get node
# Taint server, to reduce load on it
sudo k3s kubectl taint node oc0pub node-role.kubernetes.io/control-plane=true:NoSchedule

# Get token from control-plane node to be able to add agents
sudo less /var/lib/rancher/k3s/server/node-token

# Install agent nodes
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -


# Run kubectl
sudo k3s kubectl COMMAND


# Uninstall
/usr/local/bin/k3s-uninstall.sh # Server
/usr/local/bin/k3s-agent-uninstall.sh # Agent
