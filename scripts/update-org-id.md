## Update Tyk Dashboard Org via REST

1. Retrieve the org object

-Get the org-id from the Dashboard User Profile

-The `admin-auth` is the `admin_secret` in "tyk_analytics.conf"
```
curl localhost:3000/admin/organisations/{org-id} --header "admin-auth:12345" > org.json
```

2. Add "key_request_event" to the "event_options" object
```
"event_options": {
     "key_request_event": {
            "email": "",
            "redis": false,
            "webhook": "https://96f029def9c9912cdd1f309cce7d98e4.m.pipedream.net"
     }
}
```

2. Update the Org
```
$ curl -X PUT -d @org.json --header "admin-auth:12345" \
    localhost:3000/admin/organisations/{org-id} 
    
{"Status":"OK","Message":"Org updated","Meta":null}
```
