### How to create a new Org and User

Run this script in order to create a new org (tenant) and user for that org.

**Prequisites**
1. you must have `jq` installed

## 0.  Export your admin-auth for your control plane:

You need to use your admin-auth, that's the `HomeDeploymentAdminSec`

```
$ export ADMINAUTH=35623631356165652d386432652d343630362d383331342d326539333633663565356163
$ export BASEURL='https://broken-average-adm.aws-use1.cloud-ara.tyk.io'
```

## 1.  Create a new org using the special admin API:

You can copy and paste the following command.
It will create a new org, and save the ORGID to an environment variable called `ORGID`

```
$ export ORGID=$(curl --location --request POST \
$BASEURL'/admin/organisations/' \
--header 'admin-auth:'$ADMINAUTH \
--header 'Content-Type: application/json' \
--data-raw '{
    "id": "",
    "owner_name": "my-org",
    "owner_slug": "",   
    "cname_enabled": true,
    "cname": "",
    "apis": [],
    "sso_enabled": false,
    "developer_quota": 0,
    "developer_count": 0,
    "event_options": {
        "hashed_key_event": {
            "webhook": "",
            "email": "",
            "redis": true
        },
        "key_event": {
            "webhook": "",
            "email": "",
            "redis": true
        }
    },
    "hybrid_enabled": true,
    "ui": {
        "languages": {},
        "hide_help": false,
        "default_lang": "",
        "login_page": {},
        "nav": {},
        "uptime": {},
        "portal_section": {},
        "designer": {},
        "dont_show_admin_sockets": false,
        "dont_allow_license_management": false,
        "dont_allow_license_management_view": false,
        "cloud": false
    },
    "org_options_meta": {}
}' | jq .Meta)
```

Test it

```
$ echo $ORGID
"5ff337efffe39c00010bfe66"
```


## 2. Create User

The following command will create an admin user for our new org, and save the response into an environment variable.

```
$ curl --location --request POST $BASEURL'/admin/users/' \
--header 'Content-Type: application/json' \
--header 'admin-auth:'$ADMINAUTH \
--data-raw '{
  "org_id":'$ORGID',
  "first_name": "myuser",
  "last_name": "helloworld",
  "email_address": "hello@world.com",
  "active": true,
  "user_permissions": { "IsAdmin": "admin" }
}' | jq .Meta | jq --arg password mypassword123 '. + {password: $password}'

{
  "api_model": {},
  "first_name": "myuser",
  "last_name": "helloworld",
  "email_address": "hello@world.com",
  "org_id": "5ff337efffe39c00010bfe66",
  "active": true,
  "id": "5ff33ae99604e8ab100133e1",
  "access_key": "e5fd5e3da7684edf61c2a7ab22a27e12",
  "user_permissions": {
    "IsAdmin": "admin"
  },
  "group_id": "",
  "password_max_days": 0,
  "password_updated": "0001-01-01T00:00:00Z",
  "PWHistory": [],
  "last_login_date": "0001-01-01T00:00:00Z",
  "created_at": "2021-01-04T15:57:29.862Z",
  "password": "mypassword123"
}
```

We take the `id` from above, that is our user id, and save it into an environment variable:

```
$ export USERID=5ff33ae99604e8ab100133e1
```


And now we run the following curl to set a password:

```
$ curl --location --request PUT $BASEURL'/admin/users/'$USERID \
--header 'Content-Type: application/json' \
--header 'admin-auth:'$ADMINAUTH \
--data-raw '{
  "api_model": {},
  "first_name": "myuser",
  "last_name": "helloworld",
  "email_address": "hello@world.com",
  "org_id": "5ff337efffe39c00010bfe66",
  "active": true,
  "id": "5ff33b5e9604e8ab10016433",
  "access_key": "3d79edf821264cdc7ab27640bac300f8",
  "user_permissions": {
    "IsAdmin": "admin"
  },
  "group_id": "",
  "password_max_days": 0,
  "password_updated": "0001-01-01T00:00:00Z",
  "PWHistory": [],
  "last_login_date": "0001-01-01T00:00:00Z",
  "created_at": "2021-01-04T15:59:26.685Z",
  "password": "mypassword123"
}'
  

{"Status":"OK","Message":"User updated",...}%     
```

That's it!

Now we can log in with:

```
zaid@tyk.io
mypassword123
```