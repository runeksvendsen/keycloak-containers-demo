#!/bin/sh

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
KEYCLOAK_REALM="master"
# NB: see docker-compose.yml: "KEYCLOAK_ADMIN_USER", "KEYCLOAK_ADMIN_PASSWORD"
KEYCLOAK_USER="admin"
KEYCLOAK_SECRET="admin"

## Obtain Keycloak access token
echo "Attempting to obtain access token..."
ACCESS_TOKEN=$(curl --silent --show-error \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "username=${KEYCLOAK_USER}" \
  --data "password=${KEYCLOAK_SECRET}" \
  --data "grant_type=password" \
  --data 'client_id=admin-cli' \
  "${KEYCLOAK_URL}/auth/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token"|jq -r '.access_token')

## DEBUG: print access token
echo "[DEBUG] Access token: ${ACCESS_TOKEN}"

curl_cmd_auth () {
  curl --silent --show-error -H "Authorization: Bearer ${ACCESS_TOKEN}" "$@"
}

curl_cmd_get () {
  curl_cmd_auth -X GET -H "Accept: application/json" "$@"
}

curl_cmd_post () {
  curl_cmd_auth -X POST -H "Content-Type: application/json" "$@"
}

## Create new realm
echo "Attempting to create new realm..."
curl_cmd_post \
  --data @"realm.json" \
  "${KEYCLOAK_URL}/auth/admin/realms"

## Verify realm created
echo "Attempting to retrieve newly created realm..."
NEW_REALM_NAME=$(jq -r .realm < realm.json)
NEW_REALM_INFO=$(curl_cmd_get "${KEYCLOAK_URL}/auth/admin/realms/${NEW_REALM_NAME}"|jq -r .)
echo "$NEW_REALM_INFO"

## Import private key for realm

# generate private key for this realm, replace newline with "\n"
PEM_PRIVATE_KEY=$(openssl genrsa 2048|awk '{printf "%s\\n", $0}')
NEW_REALM_ID=$(echo "$NEW_REALM_INFO"|jq -r .id)
JSON='{"name":"imported_keystore","providerId":"rsa","providerType":"org.keycloak.keys.KeyProvider","parentId":"'"${NEW_REALM_ID}"'","config":{"priority":["100"],"enabled":["true"],"active":["true"],"algorithm":["RS256"],"privateKey":['"${PEM_PRIVATE_KEY}"'],"certificate":[]}}'
echo "Attempting to import private key..."
echo "JSON body:"
echo "$JSON"
IMPORT_PRV_KEY_RES=$(curl_cmd_post \
  --data "$JSON" \
  "${KEYCLOAK_URL}/auth/admin/realms/${NEW_REALM_NAME}/components")

echo "Response:"
echo "$IMPORT_PRV_KEY_RES"
