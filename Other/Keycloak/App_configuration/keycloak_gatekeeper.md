# Set up Keycloak Gatekeeper for Netdata
## In Keycloak itself
Under your Realm -> Client -> Create
  Client ID: Netdata
  Client Protocol: openid-connect
  Root URL: https://mon0.rudenspavasaris.id.lv
Save
Change:
  Access Type: Confidential
Go to Credentials, copy the secret to be used for Gatekeeper

Client Scopes -> Create
  Name: Netdata
  Description: Netdata
Save
Mappers -> Create:
  Name: Netdata
  Mapper Type: Audience
  Included Client Audience: Netdata
  Add to ID token: On
  Add to access token: On

Clients -> Netdata -> Client Scopes
  Add Netdata client scope to Assigned Default Client Scopes


## Generate encryption key for Keycloak Gatekeeper
`openssl enc -d -a -md sha1 -aes-256-cbc -nosalt -p`
Enter password, get out key and iv, which shall be used in conf file.
key=SOME_KEY
iv =THIS_IS_THE_ENCRYPTION_KEY
