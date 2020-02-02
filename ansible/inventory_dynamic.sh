#!/bin/bash

#app_ext_ip=35.246.249.179
#db_ext_ip=34.89.140.121

app_ext_ip=$(cat inventory.json | jq '.app.hosts.appserver.ansible_host')
db_ext_ip=$(cat inventory.json | jq '.db.hosts.dbserver.ansible_host')

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
