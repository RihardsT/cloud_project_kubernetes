######### Init on K8s
# Create root user default password:
kubectl create secret generic nextcloud-password --from-literal=password=$(cat Secrets/password)
kubectl apply -f gitlab.yaml

######### With Terraform and Ansible approach
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


######### Tests on the same single node
# Get the initial root password
kubectl exec $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab) -ti -- cat /etc/gitlab/initial_root_password


# SSH clone by passing SSH through Traefik TCP works.
git clone ssh://git@gitlab-ssh.rudenspavasaris.id.lv:4022/gitlab-instance-78aa14f2/Monitoring.git

# Testing the SSH clone inside the Gitlab container, just for lulz.
kubectl exec $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab) -ti -- bash
ssh-keygen -t ed25519 -C "test_on_gitlab" # Add the generated public key to your Gitlab user too
git clone ssh://git@localhost:22/gitlab-instance-04f68d12/Monitoring.git


########## Gitlab can run on ARM64:
https://docs.gitlab.com/ee/administration/package_information/supported_os.html
# but no official docker image yet.
# Build instructions can be found here a bit:
https://gitlab.com/gitlab-org/omnibus-gitlab/-/issues/5673

# Ready ARM64 Gitlab images
https://github.com/zengxs/gitlab-arm64
sudo nerdctl run --name gitlab -d zengxs/gitlab:ce
