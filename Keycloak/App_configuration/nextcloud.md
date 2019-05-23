https://stackoverflow.com/questions/48400812/sso-with-saml-keycloak-and-nextcloud


### Setup with Keycloak
- Locally:
```
openssl req  -nodes -new -x509  -keyout nextcloud_keycloak.key -out nextcloud_keycloak.cert
```
- In Keycloak, create a new realm. `Rudens`

- In Nextcloud:
- Install `SSO & SAML authentication` app. Open + Apps, search for SSO.
- Go to Settings -> `SSO & SAML authentication`
- `Use built-in` SAML authentication
- Configuration:
```
Identifier of the IdP:
https://parb.rudenspavasaris.id.lv/auth/realms/Rudens
URL Target of the IdP where the SP will send the Authentication Request Message:
https://parb.rudenspavasaris.id.lv/auth/realms/Rudens/protocol/saml
URL Location of IdP where the SP will send the SLO Request:
https://parb.rudenspavasaris.id.lv/auth/realms/Rudens/protocol/saml
Public X.509 certificate of the IdP: Copy the certificate from Keycloak from the Keys-tab of my-realm.
You will need to add '-----BEGIN CERTIFICATE-----' in front of the key and '-----END CERTIFICATE-----' to the end of it.
In Service Provider Data:

    Attribute, displayname: username
    Attribute, email adress: email Click Download metadata XML and save the file for the next step.

Security Settings, enable the following options:

    Indicates whether the messages sent by this SP will be signed. [Metadata of the SP will offer this info]
    Indicates whether the messages sent by this SP will be signed.
    Indicates whether the messages sent by this SP will be signed.
    Indicates a requirement for the , and elements received by this SP to be signed.
    Indicates a requirement for the elements received by this SP to be signed. [Metadata of the SP will offer this info]

Check there is a Metadata valid beside the Download metadata XML-Button
```

- In Keycloak:
```
Clients -> Add Client -> Import File
  Client SAML Endpoint: https://parb.rudenspavasaris.id.lv/auth/realms/Rudens
  Save
  Mappers -> Create
    Name: username
    Mapper Type: User Propery
    Property: username
    Friendly Name:
    SAML Attribute Name: username
    SAML Attribute NameFormat: Basic

Create user
```

### Login with previous admin account if something goes wrong?
http://vieta.rudenspavasaris.id.lv/login?direct=1
