### How to Protect an API with Auth Token & MTLS

This lets you protect an API with Tyk using both Auth Tokens & mTLS, while allowing your developers to upload client certs through the Developer Portal.

## Setup Instructions

1) Set up an API with multiple auth types selected and select auth token + mtls, base identity provided by Auth Token **OR** Import the API "api-definition.json" located in this directory

![Multiple Auth](multiple-auth.png)

#### Then Publish this API via Policy to the API Catalogue

2) In Dashboard Portal Management -> settings, select "Enable subscribing to multiple APIs with single key

This is very important - This will allow you to upload certs in a multi-auth API

#### Try it out

```
$ curl -k https://localhost:8081/mtls-auth-api/get --cert cert.pem --key key.pem
{
    "error": "Must Use Auth Token & Cert"
}

$ curl -k https://localhost:8081/mtls-auth-api/get --header "Authorization: eyJ..." --cert cert.pem --key key.pem
{
  "hello": "world"
}
```

