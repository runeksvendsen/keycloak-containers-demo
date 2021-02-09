#!/bin/bash

echo "Hello from 'test_script.sh'"

kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin --password admin
kcadm.sh get realms/master > masterrealm.json
cat masterrealm.json

echo "'test_script.sh': Done!"
