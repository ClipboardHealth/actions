#!/bin/bash -e

TFC_URL_PREFIX="https://app.terraform.io/api/v2"
TFC_WORKSPACES_URL="${TFC_URL_PREFIX}/organizations/clipboard-staffing/workspaces"
TFC_WORKSPACE_NAME="${SERVICE_NAME}-${ENVIRONMENT_NAME}"
HDR_AUTH="Authorization: Bearer ${TERRAFORM_TOKEN}"
HDR_CNTT="Content-Type: application/vnd.api+json"

echo "Get existent workspace id"
TFC_GET_WORKSPACE_URL="${TFC_WORKSPACES_URL}/${TFC_WORKSPACE_NAME}"
curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s "$TFC_GET_WORKSPACE_URL" -o workspace.json
WORKSPACE_ID=$(cat workspace.json | jq -r .data.id)

# Create a new workspace if doesn't exists
if [[ "$WORKSPACE_ID" == "null" ]]; then
  echo "Creating new workspace, since it doesn't exist"

  cat <<EOF >new_workspace.json
  {"data": {
    "attributes": {"name": "${TFC_WORKSPACE_NAME}"},
    "type": "workspaces"
  }}
EOF

  curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s \
    --request POST -d @new_workspace.json \
    -o workspace.json \
    "$TFC_WORKSPACES_URL"

  WORKSPACE_ID=$(cat workspace.json | jq -r .data.id)
fi

WORKSPACE_NAME=$(cat workspace.json | jq -r .data.attributes.name)
WORKSPACE_TAGS=$(cat workspace.json | jq -r '.data.attributes["tag-names"][]' | sort)

echo
echo "Workspace ID:   $WORKSPACE_ID"
echo "Workspace name: $WORKSPACE_NAME"
echo "Workspace tags: $WORKSPACE_TAGS"
echo

COMMA_TAG_LIST="${TERRAFORM_TAG_LIST},${ENVIRONMENT_NAME},${SERVICE_NAME}"
echo "$COMMA_TAG_LIST" | sed -n 1'p' | tr ',' '\n' | sort >tag_list.txt

if [ "$(cat tag_list.txt)" != "$WORKSPACE_TAGS" ]; then
  echo "Tags didn't match, update workspace tags"
  while read tag; do
    JSON_TAGS=$JSON_TAGS',{"type": "tags", "attributes": {"name": "'$tag'"}}'
  done <tag_list.txt

  TFC_ADD_TAG_URL="${TFC_URL_PREFIX}/workspaces/${WORKSPACE_ID}/relationships/tags"
  echo "{\"data\": [${JSON_TAGS:1}]}" >workspace_tags.json
  curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s \
    --request POST -d @workspace_tags.json \
    $TFC_ADD_TAG_URL
fi

echo "Remove temporary files"
rm $(dirname $0)/*.{json,txt} || echo
