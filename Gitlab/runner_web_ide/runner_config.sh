### Plain docker runner
docker run -d --name rih-gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 8093:8093 \
  gitlab/gitlab-runner:alpine

docker exec -it rih-gitlab-runner gitlab-runner register
Executor: docker
Default image: ubuntu:20.04

kubectl exec $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep runner) -it -- gitlab-runner register
kubectl exec $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep runner) -it -- bash

#
sudo vi /srv/gitlab-runner/config/config.toml

[session_server]
  listen_address = "[::]:8093"
  advertise_address = "rudenspavasaris.id.lv:8093"
  session_timeout = 1800



### Just note that like this Web IDE still failed. No idea why though.
