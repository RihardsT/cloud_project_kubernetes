### Setting up ssl cert with multiple subdomains
Given that even manual certificate renewal doesn't seem to work with wildcard
certificates, decided to use the simpler TLS challenge instead.
Modified traefik.toml like so:
```
[acme.tlsChallenge]
[[acme.domains]]
  main = "rudenspavasaris.id.lv"
  sans = ["vieta.rudenspavasaris.id.lv", "doks.rudenspavasaris.id.lv", "mon.rudenspavasaris.id.lv"]
```
Stopped traefik container and let kubernetes start it back up.
Certificate was received successfully.

### Set up ssl with wildcard certificate
1. Create the traefik deployment and add the traefik.toml via volume
  - I didn't yet find a simple sample how to use configmap that holds the traefik.toml
  - How to have the configmap along with acme certs and such
1. Got wildcard cert by using Manual "interactive" method.
  - `docker run --rm -ti certbot/certbot certonly --manual`
  - With `acmeLogging = true` and `provider = "manual"` in traefik.toml
  - Follow traefik logs, find the text that has to be added to DNS record
  - `kubectl get all --all-namespaces`
  - `kubectl logs --tail 10 --follow -n kube-system traefik-ingress-controller...`
1. Added `_acme-challenge.rudenspavasaris.id.lv` TXT record with the text from log
1. Waited a long time for the DNS record to be up.
  - Several options exist to check if the TXT record is out in the interwebs:
  - `host -t txt _acme-challenge.rudenspavasaris.id.lv`
  - `dig -t txt _acme-challenge.rudenspavasaris.id.lv`
    - Add `+short` if you only want TXT entry back
  - `nslookup -q=TXT _acme-challenge.rudenspavasaris.id.lv`
1. Stopped Traefik container and allowed Kubernetes to start it back up
1. Worked for me.

### Getting cert manually (for updates and such)
docker run --rm -ti --name certbot -v $PWD/log/:/var/log/letsencrypt/  -v $PWD:/etc/letsencrypt/ certbot/certbot:v0.30.0 certonly --manual

domains:
```
*.rudenspavasaris.id.lv
```
Pretty sure that Traefik will not renew rudenspavasaris.id.lv automatically.
Will figure out how to publish the http challenge later.


### Getting the cert from the acme.json for other stuff
jq '.Certificates[1].Domain.Main' acme.json
jq '.Certificates[1] | .Key' acme.json | sed 's/"//g' | base64 -d - > wildcard.rudenspavasaris.id.lv.key
jq '.Certificates[1] | .Certificate' acme.json | sed 's/"//g' | base64 -d - > wildcard.rudenspavasaris.id.lv.cert

### Test
```
ENDPOINT="rudenspavasaris.id.lv"
openssl s_client -connect $ENDPOINT:443 -servername $ENDPOINT < /dev/null 2>&1 | openssl x509 -enddate -noout
```
### Errors
Tried to get Traefik to renew certificate, but that was unsuccessful.
Tried by adding following to traefik.toml and stopping the traefik ingress controller container.
```
[acme.dnsChallenge]
  provider = "manual"
  delayBeforeCheck = 300
[[acme.domains]]
  main = "*.rudenspavasaris.id.lv"
```
But that always errorred out like so:
```
time="2019-01-22T09:34:36Z" level=error msg="Error renewing certificate from LE: {*.rudenspavasaris.id.lv []}, acme: Error -> One or more domains had a problem:\n[*.rudenspavasaris.id.lv] [*.rudenspavasaris.id.lv] acme: error presenting token: EOF\n"
```
