# Love it. Nice and easy.
https://longhorn.io/
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.1/deploy/longhorn.yaml


# Remove
kubectl -n longhorn-system edit settings.longhorn.io deleting-confirmation-flag
# Set ^^ the value to true
kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.1/uninstall/uninstall.yaml
kubectl get job/longhorn-uninstall -n longhorn-system -w

kubectl delete -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.1/deploy/longhorn.yaml
kubectl delete -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.1/uninstall/uninstall.yaml

# Force removal of the namespace, if there are issues
NAMESPACE='longhorn-system'
kubectl get namespace $NAMESPACE -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/$NAMESPACE/finalize -f -
# Not sure if it works for specific resource too
kubectl get -o json -n longhorn-system nodes.longhorn.io htz1 | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" | kubectl replace --raw /longhorn.io/v1beta2/nodes.longhorn.io/htz1/finalize -f -
