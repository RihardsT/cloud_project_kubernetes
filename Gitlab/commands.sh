### Backup
kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab) -- bash -c 'gitlab-backup create'

ssh -o "StrictHostKeyChecking=no" $(terraform output -state=/home/rihards/Code/cloud_project/cloud_project_terraform_gcp/terraform.tfstate | grep -oP '"\K[^"]+') 'sudo s3cmd put /data/gitlab/data/backups/$(sudo ls /data/gitlab/data/backups/) /data/gitlab/config/gitlab-secrets.json s3://rudenspavasaris'

###
# For some reason, Gitlab is not accessible from the beggining, when the VM is created.
# Container restart fixes that.
kubectl scale deployment gitlab --replicas=0
kubectl scale deployment gitlab --replicas=1

# Check if you can access it from another container
kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep nextcloud) -- bash -c 'curl -k https://gitlab'

# To trigger certificate generation, remove the previously generated certificates,
# to re-trigger Letsencrypt
kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab) -- bash -c 'rm /etc/gitlab/ssl/gitlab* && gitlab-ctl reconfigure'
kubectl logs --follow $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab)
