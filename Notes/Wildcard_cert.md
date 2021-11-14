##### Get them certs!
Getting wildcard cert by using certbot "interactive" method for
Gitlab Pages supposedly.
Make sure to have volume for Lets Encrypt,
because it will exit after successful command. Lost a cert that way. Lol

`docker run --rm -ti -v /data/letsencrypt:/etc/letsencrypt/ certbot/certbot certonly --manual`

Added `_acme-challenge.rudenspavasaris.id.lv` TXT record in NIC.  
Waited a long time for the DNS record to be up.
- Several options exist to check if the TXT record is out in the interwebs:
- `host -t txt _acme-challenge.rudenspavasaris.id.lv`
- `dig -t txt _acme-challenge.rudenspavasaris.id.lv`
  - Add `+short` if you only want TXT entry back
- `nslookup -q=TXT _acme-challenge.rudenspavasaris.id.lv`


Certificate is saved at: /etc/letsencrypt/live/rudenspavasaris.id.lv/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/rudenspavasaris.id.lv/privkey.pem
