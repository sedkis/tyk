## 1.  Create a Policy that gives access to one or more APIs
We will need our Policy ID for the next step.
Here's a video on how to create a Policy:
https://tyk.io/docs/try-out-tyk/tutorials/create-security-policy/

## 2.  Import your key via the API

The API to import Keys is via the Dashboard API, at `POST /api/keys/{custom_key}`

The  payload to send it is the Key details we want Tyk to enforce, such as access rights, rate limiting, etc.  Instead of managing these at the key level, we want to use the Policy that all keys will inherit from.

here's our payload:
```json
{
    "expires": 0,
    "allowance": 0,
    "per": 0,
    "quota_max": 0,
    "rate": 0,
    "apply_policies": [
      "5ecc0b91081ac40001ed261c"
    ],
    "org_id" : "5eb06f441fe4c4000147476e"
}
```

1.  Expires=0  for a never expiring key.  Otherwise, pass it an EPOCH date for the future, such as `1568658788`
2.  Insert our Policy  ID from step 1 into the "apply_policies" field array.
3.  We need to also pass our `org_id` as the Dashboard is a multi-tenant system.  We can get the org ID from the Dashboard's User Profile page.
4.  We need to authenticate our API call passing an auth header with our Dashboard User's API key.  This is also found in the Dashboard's User Profile page.

Putting it all  together, here is how we import a key called "abcd". (minimum key length is 4, but you should treat this like a password.  the longer, more complex, the better)

```
$ curl http://localhost:3000/api/keys/abcd \
--header "authorization: db519ab633194b3c58553904d2e53aab" \
--data '
{
    "expires": 0,
    "allowance": 0,
    "per": 0,
    "quota_max": 0,
    "rate": 0,
    "apply_policies": [
      "5ecc0b91081ac40001ed261c"
    ],
    "org_id" : "5eb06f441fe4c4000147476e"
}'
```

Response:
```
{"api_model":{},"key_id":"5eb06f441fe4c4000147476eabcd","data":{"last_check":0,"allowance":0,"rate":1000,"per":60,"throttle_interval":0,"throttle_retry_limit":0,"date_created":"2020-05-25T18:44:52.2700758Z","expires":0,"quota_max":0,"quota_renews":0,"quota_remaining":0,"quota_renewal_rate":3600,"access_rights":{"2bf3066b8d27439142c178c9750a9777":{"api_name":"users api","api_id":"2bf3066b8d27439142c178c9750a9777","versions":["Default"],"allowed_urls":[],"limit":{"rate":1000,"per":60,"throttle_interval":0,"throttle_retry_limit":0,"quota_max":0,"quota_renews":0,"quota_remaining":0,"quota_renewal_rate":3600,"set_by_policy":false},"allowance_scope":""}},"org_id":"5eb06f441fe4c4000147476e","oauth_client_id":"","oauth_keys":null,"certificate":"","basic_auth_data":{"user":"","password":"","hash_type":""},"jwt_data":{"secret":""},"hmac_enabled":false,"hmac_string":"","is_inactive":false,"apply_policy_id":"","apply_policies":["5ecc0b91081ac40001ed261c"],"data_expires":0,"monitor":{"trigger_limits":null},"enable_detail_recording":false,"meta_data":{},"tags":[],"alias":"","last_updated":"1590432292","id_extractor_deadline":0,"session_lifetime":0},"key_hash":"4511ae93"}
```

We get confirmation that Tyk created a key for us.  Now we can use our "abcd" key to access an API 
```
$ curl localhost:8080/users-api/users/1 --header "Authorization: abcd"
{
  "response" : "hello world"
}
```
