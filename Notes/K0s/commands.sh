# https://docs.k0sproject.io/stable/
# K0s should have even less system requirements than k3s
# https://docs.k0sproject.io/stable/system-requirements/

# So far works great with very small nodes.
# Separate Controller and worker node, both with 1CPU and 1GB RAM

# Install k0sctl locally (with fish)
set GITHUB_PROJECT "k0sproject/k0sctl"
wget $(curl --silent "https://api.github.com/repos/$GITHUB_PROJECT/releases/latest" | jq -r ".assets[].browser_download_url" | grep "linux-amd")
sudo mv k0sctl-linux-amd64 /usr/bin/k0sctl && chmod +x /usr/bin/k0sctl
sudo chmod +x /usr/bin/k0sctl

# init controller. Run locally
k0sctl init > k0sctl.yaml
# remove worker node first and set ip to localhost
k0sctl apply --config k0sctl.yaml
# If you don't have other cluster, put kubeconfig in it's default place
k0sctl kubeconfig > ~/.kube/config


# Run on server
sudo ln -s /usr/bin/k0s /usr/local/bin/k0s
sudo chmod +x /usr/local/bin/k0s

# Add a worker node
# Add a host with worker role in k0sctl.yaml and run k0sctl apply again
k0sctl apply --config k0sctl.yaml

# Logs are in journalctl
sudo journalctl -u k0sworker | grep component=kubelet
sudo journalctl -u k0sworker | grep "kube-system/konnectivity-agent-tzvr9"
