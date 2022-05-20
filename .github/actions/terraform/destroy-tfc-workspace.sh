#!/bin/bash

set -e

TFC_WORKSPACE_NAME="${SERVICE_NAME}-${ENVIRONMENT_NAME}"
HDR_AUTH="Authorization: Bearer ${TERRAFORM_TOKEN}"
HDR_CNTT="Content-Type: application/vnd.api+json"

echo "Get existant workspace id"
curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s \
  "https://app.terraform.io/api/v2/organizations/clipboard-staffing/workspaces/${TFC_WORKSPACE_NAME}" \
  -o workspace.json
WORKSPACE_ID=$(cat workspace.json | jq -r .data.id)

echo
echo "Workspace name: $TFC_WORKSPACE_NAME"
echo "Workspace ID:   $WORKSPACE_ID"
echo

# Create a new workspace if doesn't exists
if [ "$WORKSPACE_ID" = "null" ]; then
  echo "Workspace does exists, so cannot be deleted"
  exit 1
fi

curl -H "$HDR_AUTH" -H "$HDR_CNTT" -s \
  --request DELETE \
  -o destroy_workspace.json \
  "https://app.terraform.io/api/v2/admin/workspaces/${WORKSPACE_ID}"

if [ "$(cat destroy_workspace.json | jq -r '.errors')" = "null" ]; then
  echo "Workspace destroyed!"
else
  echo "Error during workspace destruction: " \
    "$(cat destroy_workspace.json | jq -r '.errors[].title')"
  exit 2
fi

echo "Remove temporary files"
rm destroy_workspace.json
