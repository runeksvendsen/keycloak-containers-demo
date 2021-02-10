#!/bin/bash

KEYCLOAK_PORT=8080
KEYCLOAK_URL="http://localhost:$KEYCLOAK_PORT"

# wait until Keycloak is up and running
RETRY_COUNT=20
RETRY_DELAY_SECONDS=10
EXIT_STATUS=1
for i in $(seq 1 $RETRY_COUNT); do
    curl --fail --retry-connrefused "$KEYCLOAK_URL"
    EXIT_STATUS=$?
    if [ "$EXIT_STATUS" -eq "0" ]; then
        break
    fi
    echo "Retrying in $RETRY_DELAY_SECONDS seconds..."
    sleep $RETRY_DELAY_SECONDS
done
if [ "$EXIT_STATUS" -neq "0" ]; then
    echo "Failed to connect to Keycloak server"
    exit "$EXIT_STATUS"
fi


#### Configure Keycloak ####

CURL_CMD="curl --silent --show-error"
KEYCLOAK_REALM="master"
# NB: see docker-compose.yml: "KEYCLOAK_ADMIN_USER", "KEYCLOAK_ADMIN_PASSWORD"
KEYCLOAK_USER="admin"
KEYCLOAK_SECRET="admin"

## Obtain access token
ACCESS_TOKEN=$(${CURL_CMD} \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=${KEYCLOAK_USER}" \
  -d "password=${KEYCLOAK_SECRET}" \
  -d "grant_type=password" \
  -d 'client_id=admin-cli' \
  "${KEYCLOAK_URL}/auth/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token"|jq -r '.access_token')

## DEBUG: print access token
echo -n "[DEBUG] Access token: "
echo ${ACCESS_TOKEN}

## Create new realm
REALM_FILE="realm.json";
${CURL_CMD} \
  -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d @"${REALM_FILE}" \
  "${KEYCLOAK_URL}/auth/admin/realms"


## Verify realm created
NEW_REALM_NAME=$(cat realm.json|jq -r .realm)
${CURL_CMD} \
  -X GET \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "${KEYCLOAK_URL}/auth/admin/realms/${NEW_REALM_NAME}"|jq -r .|head
