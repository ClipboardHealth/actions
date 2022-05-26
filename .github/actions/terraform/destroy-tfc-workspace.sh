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

echo
echo "Workspace name: $TFC_WORKSPACE_NAME"
echo "Workspace ID:   $WORKSPACE_ID"
echo

# Create a new workspace if doesn't exists
if [ "$WORKSPACE_ID" == null ]; then
  echo "Workspace does not exist, so cannot be deleted"
  exit 1
fi

echo "Delete workspace if it exists"
TFC_DELETE_WORKSPACE_URL="${TFC_WORKSPACES_URL}/${TFC_WORKSPACE_NAME}"
curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s --request DELETE -o destroy_workspace.json "$TFC_DELETE_WORKSPACE_URL"
WORKSPACE_ID=$(curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s "$TFC_GET_WORKSPACE_URL" | jq -r .data.id)

if [ "$WORKSPACE_ID" == "null" ]; then
  echo "Workspace destroyed!"
else
  echo "Error during workspace destruction: " \
    "$(cat destroy_workspace.json | jq -r '.errors[].title')"
  exit 2
fi

echo "Remove temporary files"
rm destroy_workspace.json || echo
