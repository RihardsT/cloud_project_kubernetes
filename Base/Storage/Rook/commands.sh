https://rook.io/docs/rook/v1.7/quickstart.html


cd ~/Code/Other_repos
git clone --single-branch --branch release-1.7 https://github.com/rook/rook.git

cd ~/Code/Other_repos/rook/cluster/examples/kubernetes/ceph
kubectl create -f crds.yaml -f common.yaml -f operator.yaml

# Clear
cd ~/Code/cloud_project/cloud_project_kubernetes/Rook
kubectl delete -f cluster-local-pv.yaml
cd ~/Code/Other_repos/rook/cluster/examples/kubernetes/ceph
kubectl delete -f crds.yaml -f common.yaml -f operator.yaml
