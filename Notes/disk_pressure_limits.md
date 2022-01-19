### If pods get evicted due to disk pressure
Edit `/var/lib/kubelet/config.yaml` and change the default values
```
evictionHard:
  imagefs.available: 15%
  memory.available: 100Mi
  nodefs.available: 10%
  nodefs.inodesFree: 5%
```
to something that seems appropriate in your case.  
Then restart kubelet `sudo systemctl restart kubelet`

In my case, will try:
```
evictionHard:
  imagefs.available: 5%
  memory.available: 100Mi
  nodefs.available: 5%
  nodefs.inodesFree: 5%
```


### Clear Kubernetes upgrade backups
Looks like Kubeadm creates backup when upgrading Kubernetes.
That was using a lot of space on my long living server,
which led to that disk pressure.  
But I think those old backups can be removed.  
```
du -sch /etc/kubernetes/tmp/*
cd /etc/kubernetes/tmp
ls -t /etc/kubernetes/tmp | sed -e '1,4d' | xargs rm -rf
```
`ls` by time and remove first 4 entries, to keep latest 2 backups. Remove other.
