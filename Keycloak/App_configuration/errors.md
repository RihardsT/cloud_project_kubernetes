```
Account not provisioned.
Your account is not provisioned, access to this service is thus not possible.
```
Enable Nextcloud debug mode, get:
```
Signature validation failed. SAML Response rejected
```
Copied the cert from Keycloak `Realm -> Keys -> RSA Certificate` to Nextcloud
Wrap the cert in `-----BEGIN CERTIFICATE-----CERT_HERE-----END CERTIFICATE-----` before copying it to Nextcloud

Next error:
```
Found an Attribute element with duplicated Name
```
Fix was:
```
Client Scopes -> role_list -> Mappers
  Enable Single Role Attribute
  Save
```
