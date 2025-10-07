# Love it. Nice and easy.
https://longhorn.io/
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/$LONGHORN_VERSION/deploy/longhorn.yaml


# Remove
kubectl -n longhorn-system patch -p '{"value": "true"}' --type=merge lhs deleting-confirmation-flag
LONGHORN_VERSION="v1.10.0"
kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/${LONGHORN_VERSION}/uninstall/uninstall.yaml
kubectl get job/longhorn-uninstall -n longhorn-system -w

kubectl delete -f https://raw.githubusercontent.com/longhorn/longhorn/$LONGHORN_VERSION/deploy/longhorn.yaml
kubectl delete -f https://raw.githubusercontent.com/longhorn/longhorn/$LONGHORN_VERSION/uninstall/uninstall.yaml

# Force removal of the namespace, if there are issues
NAMESPACE='longhorn-system'
kubectl get namespace $NAMESPACE -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/$NAMESPACE/finalize -f -
# Not sure if it works for specific resource too
kubectl get -o json -n longhorn-system nodes.longhorn.io htz1 | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" | kubectl replace --raw /longhorn.io/v1beta2/nodes.longhorn.io/htz1/finalize -f -
