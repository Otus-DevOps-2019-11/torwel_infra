#!/bin/bash

# Get IP addresses from terraform fariables
app_ext_ip=\"$(cd ../terraform/prod && terraform output app_external_ip)\"
db_ext_ip=\"$(cd ../terraform/prod && terraform output db_external_ip)\"


# Parse IP addresses from static json-inventory
#app_ext_ip=$(cat inventory.json | jq '.app.hosts.appserver.ansible_host')
#db_ext_ip=$(cat inventory.json | jq '.db.hosts.dbserver.ansible_host')


if [ "$1" == "--list" ] ; then
cat<<EOF
{
   "app": {
        "hosts": [$app_ext_ip]
    },
   "db": {
        "hosts": [$db_ext_ip]
    },
    "_meta": {
        "hostvars": {}
    }
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
