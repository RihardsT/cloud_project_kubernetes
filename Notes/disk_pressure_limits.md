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
