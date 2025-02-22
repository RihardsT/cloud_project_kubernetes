######### TODO:
# Get this, to be able to create separate amd64 node, to run Kasm on.
https://stackoverflow.com/questions/52487333/how-to-assign-a-namespace-to-certain-nodes
https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/


CertificateApproval, CertificateSigning, CertificateSubjectRestriction, DefaultIngressClass, DefaultStorageClass, DefaultTolerationSeconds, LimitRanger, MutatingAdmissionWebhook, NamespaceLifecycle, PersistentVolumeClaimResize, PodSecurity, Priority, ResourceQuota, RuntimeClass, ServiceAccount, StorageObjectInUseProtection, TaintNodesByCondition, ValidatingAdmissionPolicy, ValidatingAdmissionWebhook

# Kasm
https://github.com/kasmtech/kasm-helm


cd ~/Code/Other_repos
git clone https://github.com/kasmtech/kasm-helm.git

cd ~/Code/Other_repos/kasm-helm
helm install kasm kasm-single-zone --namespace kasm --create-namespace --values ~/Code/cloud_project/cloud_project_kubernetes/Other_WIP/Kasm/values.yaml



k get secrets -n kasm
k get secrets -n kasm kasm-secrets -o json | jq '.data | map_values(@base64d)'

admin@kasm.local
user@kasm.local

### Create custom images, main idea are arm64 images
https://www.kasmweb.com/docs/latest/how_to/building_images.html
https://www.kasmweb.com/docs/latest/guide/custom_images.html
