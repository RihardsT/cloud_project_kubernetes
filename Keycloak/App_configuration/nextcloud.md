https://stackoverflow.com/questions/48400812/sso-with-saml-keycloak-and-nextcloud


### Setup with Keycloak
- Locally:
```
openssl req  -nodes -new -x509  -keyout nextcloud_keycloak.key -out nextcloud_keycloak.cert
```
- In Keycloak, create a new realm. `Rudens`
 - Under `Login` enable Remember Me
 - Under `Keys` click on Certificate button
 - Copy the certificate to a safe place
 - fold -w64 certificate
 - Wrap the cert in `-----BEGIN CERTIFICATE-----CERT_GOES_HERE-----END CERTIFICATE-----`

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
Public X.509 certificate of the IdP: Copy the certificate got from the Keycloak steps above
In Service Provider Data:

    Attribute, displayname: username
    Attribute, email adress: email Click Download metadata XML and save the file for the next step.

Security Settings, enable the following options:

    Indicates whether the <samlp:AuthnRequest> messages sent by this SP will be signed. [Metadata of the SP will offer this info]
    Indicates whether the <samlp:logoutRequest> messages sent by this SP will be signed.
    Indicates whether the <samlp:logoutResponse> messages sent by this SP will be signed.
    Indicates a requirement for the <samlp:Response>, <samlp:LogoutRequest> and <samlp:LogoutResponse> elements received by this SP to be signed.
    Indicates a requirement for the <saml:Assertion> elements received by this SP to be signed. [Metadata of the SP will offer this info]

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

Client Scopes -> role_list -> Mappers
  Click/open role list
  Enable Single Role Attribute
  Save

Create user
```

### Login with previous admin account if something goes wrong?
https://vieta.rudenspavasaris.id.lv/login?direct=1
