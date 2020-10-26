1. Spin up an EC2 instance, AWS Linux2 preferably, T2.Medium is fine
- add a public IP
- open up SG access to 3000, 8080, 22 TCP.  (The first two are Tyk DB and GW respectively, the last one is for SSH)

2. SSH into the instance
`ssh -i mykey.pem ec2-user@public-ec2-ip`

3. Install git, Docker, & Docker Compose
Feel free to copy paste these
```sh
sudo yum update -y
sudo yum install git -y
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user
sudo su
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker ps
```

4. Clone the Tyk Pro repo
```bash
git clone https://github.com/TykTechnologies/tyk-pro-docker-demo
cd tyk-pro-docker-demo/
```

5. Add the license key to "confs/tyk_analytics.conf" into "license_key" variable using "vi" or "nano" or something else

**This is the most common place to have problems.**

**Look for extra spaces between quotes ("") and the license key.  It will not work if there are any.**

Inside `tyk_analytics.conf`, `license_key` should look something like this, with a real license however:

`
"license_key": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhbGxvd2VkMzU5My00NWZlLTY4YjItMmUxMDc3NDdjZmE4LDFmNjllMTgzLWZkODUtNGViNS02NzgwLWYzODllMjdkMjkyYiw1ODRhZjhiMi1hNDI4LTQwMDQtNzI2Ni01ZDk4ZDQ4Y2U2MDIsYjZjZDBiZjAtM2Y5OC00MzFkLTQ4YTctYjNkYmY3ZDAyYTU1LDIzYjBhNmRkLTlmODctNDAxOC00MDkyLTllODdkNzUxODE1YSw1ODgyMDBlZi1jYjEyLTRhZjctN2YwMi05OGNlN2FlOGVkMjIsNjJlZTI3MDUtZDJlYi00YzEzLTY2NTAtNmZmNjU2ZGUyMTE3LDQ5OTk2NzU5LTgwOTYtNGYwYS03YWFkLTYzYzA4MjhmODQ5NixhN2I4NzM5MC03YWE4LTRlYzktNThhZC04OWYyZGI5YmJlZGMsZmU4ZDhiOGEtNzkzOC00ZTY2LTRmOTAtYTViNjQ5MTVlOTI5LDYwMDY0Zjk1LTAxZjgtNDc4Ny01MTk4LWI2NmZjMGM2ZTJlOCxhZDQxMzVjYi1mNDJjLTRhYjAtNDBmMC0yNzcyYTg4NzdjYzEsMmY4NGNhOTgtMGNiNC00ZGYxLTVhNTUtNzJiYWQyNTVlNWVhLDcyNmY1M2QxLThmMmMtNGIwNy02ZGIzLTQ2MjNhNmY0ZjgxMixlOTc3YTc0OS02NWE2LTRiOGItNDAyNS04Y2UzMWNmYjYzNzQsNjI5NjJkMmMtODgxZC00YTE4LTdkMDgtY2RmYmNiNDVhZjA4LGYzNjdmNWVkLTFlNjktNDlkZC03YzZkLWFiOWQ2N2FlMjc4ZSxhZDM1MDZiMS1kMmUzLTRhZTItNmEwMC1iN2JjOGNjYWU3NjYsNjk3MjNjMmEtZmZiMzU5My00NWZlLTY4YjItMmUxMDc3NDdjZmE4LDFmNjllMTgzLWZkODUtNGViNS02NzgwLWYzODllMjdkMjkyYiw1ODRhZjhiMi1hNDI4LTQwMDQtNzI2Ni01ZDk4ZDQ4Y2U2MDIsYjZjZDBiZjAtM2Y5OC00MzFkLTQ4YTctYjNkYmY3ZDAyYTU1LDIzYjBhNmRkLTlmODctNDAxOC00MDkyLTllODdkNzUxODE1YSw1ODgyMDBlZi1jYjEyLTRhZjctN2YwMi05OGNlN2FlOGVkMjIsNjJlZTI3MDUtZDJlYi00YzEzLTY2NTAtNmZmNjU2ZGUyMTE3LDQ5OTk2NzU5LTgwOTYtNGYwYS03YWFkLTYzYzA4MjhmODQ5NixhN2I4NzM5MC03YWE4LTRlYzktNThhZC04OWYyZGI5YmJlZGMsZmU4ZDhiOGEtNzkzOC00ZTY2LTRmOTAtYTViNjQ5MTVlOTI5LDYwMDY0Zjk1LTAxZjgtNDc4Ny01MTk4LWI2NmZjMGM2ZTJlOCxhZDQxMzVjYi1mNDJjLTRhYjAtNDBmMC0yNzcyYTg4NzdjYzEsMmY4NGNhOTgtMGNiNC00ZGYxLTVhNTUtNzJiYWQyNTVlNWVhLDcyNmY1M2QxLThmMmMtNGIwNy02ZGIzLTQ2MjNhNmY0ZjgxMixlOTc3YTc0OS02NWE2LTRiOGItNDAyNS04Y2UzMWNmYjYzNzQsNjI5NjJkMmMtODgxZC00YTE4LTdkMDgtY2RmYmNiNDVhZjA4LGYzNjdmNWVkLTFlNjktNDlkZC03YzZkLWFiOWQ2N2FlMjc4ZSxhZDM1MDZiMS1kMmUzLTRhZTItNmEwMC1iN2JjOGNjYWU3NjYsNjk3MjNjMmEtZmZiEQsnWheJWQ",
`

6. Run the containers via docker-compose

```bash
docker-compose -f docker-compose.yml -f docker-local.yml up -d
```

7. Visit 
```
http://<public-ec2-ip>:3000
```
and fill out the Bootstrap form!
**If you see any page besides the Bootstrap page, you have pasted the license key incorrectly**


# Enable SSL for Gateway & Dashboard

1. Add these to `confs/tyk.conf`
```
"policies.policy_connection_string": "https://tyk-dashboard:3000"
"db_app_conf_options.connection_string": "https://tyk-dashboard:3000"
"http_server_options": {
  "use_ssl": true,
  "certificates": [
    {
      "domain_name": "*.yoursite.com",
      "cert_file": "./new.cert.cert",
      "key_file": "./new.cert.key"
    }
  ],
  "ssl_insecure_skip_verify": true   ### YOU ONLY NEED THIS IF YOU ARE USING SELF SIGNED CERTS
}
```

2. Add these to `confs/tyk_analytics.conf`
```json
"tyk_api_config.Host": "https://tyk-gateway"
"http_server_options": {
  "use_ssl": true,
  "certificates": [
    {
      "domain_name": "*.yoursite.com",
      "cert_file": "./new.cert.cert",
      "key_file": "./new.cert.key"
    }
  ]
}
```

3. Generate self-signed Certs: (Or bring your own CA signed)
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
```

4. Mount them to containers through `docker-compose.yml`
```
tyk-dashboard:
    ...
    volumes: 
    - ./cert.pem:/opt/tyk-dashboard/new.cert.cert
    - ./key.pem:/opt/tyk-dashboard/new.cert.key
tyk-gateway:
    ...
    volumes: 
    - ./cert.pem:/opt/tyk-gateway/new.cert.cert
    - ./key.pem:/opt/tyk-gateway/new.cert.key
```

5. Restart containers with mounted files
```
docker-compose -f docker-compose.yml -f docker-local.yml up -d tyk-dashboard tyk-gateway
```

6. Download the bootstrap script onto EC2 machine
```
wget https://gist.githubusercontent.com/sedkis/6f0510445b984b0b70f88564b244020f/raw/f739181cad0e994d2ea6f9022cab1e0ebc55dfd8/bootstrap.sh
```

7. Apply execute permissions to file:
```chmod +x bootstrap.sh```

8. Run the bootstrap script
```./bootstrap.sh localhost```

9. Done! use generated user+pw to log into DB



bootstrap.sh
```
#!/bin/bash

main(){
  PYTHON_BIN="$(command -v python || command -v python3)"
  if [[ $# -lt 1 ]]
    then
      syntax_message
  elif [ -z $(which curl) ]
    then
      curl_message
  elif [ -z "$PYTHON_BIN" ]
    then
      python_message
    else
      echo "Found Python interpreter at: $PYTHON_BIN"
      LOCALIP=$(check_host $1)
      RANDOM_USER=$(env LC_CTYPE=C tr -dc "a-z0-9" < /dev/urandom | head -c 10)
      PASS="t2e0s1T7"
      generate_credentials "$LOCALIP" $RANDOM_USER $PASS
      exit_reason "$?"
  fi
}

syntax_message() {
  echo 'SYNTAX ERROR: Usage `./bootstrap.sh DASHBOARD_HOSTNAME`'
  exit 1
}

curl_message() {
  echo 'ERROR: Please install cURL'
  exit 1
}

python_message() {
  echo 'ERROR: Please install Python and ensure that you are able to run the `python` command within the terminal'
  exit 1
}

check_host(){
  [[ $1 == *:* ]] && echo "" || echo $1
}

generate_credentials(){
  error=0
  [[ -z "$1" ]] && return "6" || echo ""
  error="$?"
  [[ $error != 0 ]] && return $error
  echo "Creating Organisation"
  ORGDATA=$(create_organisation $1)
  error="$?"
  [[ $error != 0 ]] && return $error || echo "ORG DATA: $ORGDATA"
  ORGID=$(org_id "$ORGDATA")
  error="$?"
  [[ $? != 0 ]] && return $error || echo "ORG ID: $ORGID"
  echo ""
  echo "Adding new user"
  USER_AUTH_CODE=$(create_user $1 $2 $3 $ORGID)
  error=$?
  [[ $error != 0 ]] && return $error || echo "USER AUTHENTICATION CODE: $USER_AUTH_CODE"
  USER=$(get_user $1 $USER_AUTH_CODE)
  error=$?
  [[ $? != 0 ]] && return $error
  USERID=$(get_user_id "$USER")
  error=$?
  [[ $error != 0 ]] && return $error || echo "NEW ID: $USERID"
  EMAIL=$(get_user_email "$USER")
  error=$?
  [[ $? != 0 ]] && return $error
  echo ""
  echo "Setting password"
  setting_password $1 $USER_AUTH_CODE $3
  error=$?
  [[ $? != 0 ]] && return $error

  output $1 $EMAIL $3
}

exit_reason(){
  case "$1" in
    "3")
      echo "ERROR: Unable to connect to the Dashboard. Please check that you are using the correct hostname."
      exit $1
      ;;
    "4")
      echo "ERROR: Unable to parse JSON"
      exit $1
      ;;
    "5")
      echo "Unexpected error"
      exit $1
      ;;
    "6")
      echo "ERROR: Hostname should not contain port number or protocol"
      ;;
    *)
      echo ""
      ;;
  esac
}

if_present_echo(){
  [[ -z "$1" ]] && return $2 || echo "$1"
}

create_organisation() {
  ORGDATA=$(curl -k --silent --header "admin-auth: 12345" --header "Content-Type:application/json" --data '{"owner_name": "Default Org.","owner_slug": "default", "cname_enabled": true, "cname": ""}' https://$1:3000/admin/organisations 2>&1)
  if_present_echo "$ORGDATA" 3
}

org_id(){
  ORGID=$(echo $1 | ${PYTHON_BIN} -c 'import json,sys;obj=json.load(sys.stdin);print(obj["Meta"])')
  if_present_echo $ORGID 4
}

create_user(){
  USER_DATA=$(user_data $1 $2 $3 $4)
  AUTH_CODE=$(echo $USER_DATA | ${PYTHON_BIN} -c 'import json,sys;obj=json.load(sys.stdin);print(obj["Message"])')
  if_present_echo "$AUTH_CODE" 4
}

user_data(){
  user_curl=$(curl -k --silent --header "admin-auth: 12345" --header "Content-Type:application/json" --data '{"first_name": "Joan","last_name": "Smith","email_address": "'$2'@default.com","password":"'$3'", "active": true,"org_id": "'$4'"}' https://$1:3000/admin/users 2>&1)
  if_present_echo $user_curl 3
}

get_user(){
  USER_LIST=$(get_user_list $1 $2)
  USER=$(get_last_user $USER_LIST)
  if_present_echo "$USER" 5
}

get_user_list(){
  list=$(curl -k --silent --header "authorization: $2" https://$1:3000/api/users 2>&1)
  if_present_echo "$list" 3
}

get_user_id(){
  export user=$1
  id=$(${PYTHON_BIN} -c "import json,os,string;user_str=os.environ['user'];print(json.loads(user_str)['id'])")
  if_present_echo "$id" 4
}

get_user_email(){
  export user=$1
  email=$(${PYTHON_BIN} -c "import json,os,string;user_str=os.environ['user'];print(json.loads(user_str)['email_address'])")
  if_present_echo "$email" 4
}

get_last_user(){
  user_parsed=$(echo $1 | ${PYTHON_BIN} -c 'import json,sys;obj=json.load(sys.stdin);print(json.dumps(obj["users"][0]))')
  if_present_echo "$user_parsed" 4
}

setting_password(){
  USER=$(get_user $1 $2)
  USERID=$(get_user_id "$USER")
  response=$(curl -k --silent --header "authorization: $2" --header "Content-Type:application/json" https://$1:3000/api/users/$USERID/actions/reset --data '{"new_password":"'$3'"}')
  if_present_echo "$response" 3
}

output(){
  echo ""
  echo "DONE"
  echo "===="
  echo "Login at https://$1:3000/"
  echo "User: $2"
  echo "Pass: $3"
}

main $1 $2
```
