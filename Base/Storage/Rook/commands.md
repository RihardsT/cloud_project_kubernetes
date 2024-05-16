### Quickstart, nice and easy now
https://rook.io/docs/rook/latest-release/Getting-Started/quickstart/
```
git clone --single-branch --branch v1.14.3 https://github.com/rook/rook.git ~/Code/Other_repos/rook
cd ~/Code/Other_repos/rook/deploy/examples
kubectl create -f crds.yaml -f common.yaml -f operator.yaml
kubectl create -f cluster.yaml
```

### Remove
```
cd ~/Code/Other_repos/rook/deploy/examples
kubectl delete -f cluster.yaml
kubectl delete -f crds.yaml -f common.yaml -f operator.yaml
```

### Old, deprecated:
```
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
```
