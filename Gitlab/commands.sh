kubectl exec -it $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab) -- bash
gitlab-backup create

ssh -o "StrictHostKeyChecking=no" $(terraform output -state=/home/rihards/Code/cloud_project/cloud_project_terraform_gcp/terraform.tfstate | grep -oP '"\K[^"]+')
sudo s3cmd put /data/gitlab/data/backups/$(ls /data/gitlab/data/backups/) s3://rudenspavasaris

Copy the gitlab-secrets.json too
