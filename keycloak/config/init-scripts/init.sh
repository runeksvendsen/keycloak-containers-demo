#!/bin/bash

KEYCLOAK_PORT=8080 # see docker-compose: KEYCLOAK_HTTP_PORT
KEYCLOAK_URL="http://keycloak:$KEYCLOAK_PORT"

# wait until Keycloak is up and running
RETRY_COUNT=20
RETRY_DELAY_SECONDS=10
EXIT_STATUS=1
for i in $(seq 1 $RETRY_COUNT); do
    curl -o /dev/null --silent --fail --retry-connrefused "$KEYCLOAK_URL"
    EXIT_STATUS=$?
    if [ "$EXIT_STATUS" -eq "0" ]; then
        break
    fi
    echo "Failed to connect to Keycloak server. Retrying in $RETRY_DELAY_SECONDS seconds..."
    sleep $RETRY_DELAY_SECONDS
done
if [ "$EXIT_STATUS" -ne "0" ]; then
    echo "Failed to connect to Keycloak server"
    exit "$EXIT_STATUS"
fi

set -e

##### Install "jq" dependency #####
curl --silent -L 'https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64' -o /usr/local/bin/jq
chmod +x /usr/local/bin/jq

#### Configure Keycloak ####
CURL_CMD_ANON="curl --silent --show-error"
KEYCLOAK_REALM="master"
# NB: see docker-compose.yml: "KEYCLOAK_ADMIN_USER", "KEYCLOAK_ADMIN_PASSWORD"
KEYCLOAK_USER="admin"
KEYCLOAK_SECRET="admin"

## Obtain Keycloak access token
echo "Attempting to obtain access token..."
ACCESS_TOKEN=$(${CURL_CMD_ANON} \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "username=${KEYCLOAK_USER}" \
  --data "password=${KEYCLOAK_SECRET}" \
  --data "grant_type=password" \
  --data 'client_id=admin-cli' \
  "${KEYCLOAK_URL}/auth/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token"|jq -r '.access_token')

## DEBUG: print access token
echo -n "[DEBUG] Access token: "
echo ${ACCESS_TOKEN}

CURL_CMD_AUTH="$CURL_CMD_ANON -H \"Authorization: Bearer ${ACCESS_TOKEN}\""
CURL_CMD_AUTH_POST="$CURL_CMD_AUTH -X POST -H \"Content-Type: application/json\""

## Create new realm
echo "Attempting to create new realm..."
${CURL_CMD_AUTH_POST} \
  --data @"realm.json" \
  "${KEYCLOAK_URL}/auth/admin/realms"

## Verify realm created
echo "Attempting to retrieve newly created realm..."
NEW_REALM_NAME=$(cat realm.json|jq -r .realm)
${CURL_CMD_AUTH} \
  -X GET \
  -H "Accept: application/json" \
  "${KEYCLOAK_URL}/auth/admin/realms/${NEW_REALM_NAME}"|jq -r .|head

## Import private key for realm

# generate private key for this realm
PEM_PRIVATE_KEY=$(openssl genrsa 2048)
NEW_REALM_ID=$(cat realm.json|jq -r .id)
echo "Attempting to import private key..."
IMPORT_PRV_KEY_RES=${CURL_CMD_AUTH_POST} \
  --data '{"name":"imported_keystore","providerId":"rsa","providerType":"org.keycloak.keys.KeyProvider","parentId":"'$NEW_REALM_ID'","config":{"priority":["100"],"enabled":["true"],"active":["true"],"algorithm":["RS256"],"privateKey":['$PEM_PRIVATE_KEY'],"certificate":[]}}' \
  "${KEYCLOAK_URL}/auth/admin/realms/${NEW_REALM_NAME}/components"

echo "Response:"
echo "$IMPORT_PRV_KEY_RES"
