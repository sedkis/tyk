## The 30 second guide to importing opaque tokens into Tyk

Note, if using basic auth (user/pw), it is slightly different. you would simply create a basic auth user via different Tyk API.

Do you want to use Security Policies?

## Yes, using Policies:

Create key against Gateway API. Needs gateway secret, and policy ID.

```
curl -X POST 'localhost:8080/tyk/keys/mycustomkey' \
--header 'x-tyk-authorization: gateway-secret' \
--header 'Content-Type: application/json' \
--data-raw '{
    "quota_max": -1,
    "allowance": 100,
    "rate": 100,
    "per": 5,
    "org_id": "5e9d9544a1dcd60001d0ed20",
    "apply_policies": ["5f89a7340bca390001623452"]
}'
```

Can now curl your api with your custom-key

```
curl localhost:8080/basic-protected-api/myendpoint -H "Authorization: mycustomkey"
```

## NO, Not using policies

Add the API Ids to the `access_rights` object.

```
curl -X POST 'localhost:8080/tyk/keys/mycustomkey' \
--header 'x-tyk-authorization: gateway-secret' \
--header 'Content-Type: application/json' \
--data-raw '{
    "quota_max": -1,
    "allowance": 100,
    "rate": 100,
    "per": 5,
    "org_id": "5e9d9544a1dcd60001d0ed20",
    "access_rights": {
            "<api-id-here>": {
                "api_name": "Basic Protected API",
                "api_id": "<api-id-here>",
                "versions": [
                    "Default"
                ],
                "allowed_urls": [],
                "limit": null,
                "allowance_scope": ""
            }
        }
}'
```
