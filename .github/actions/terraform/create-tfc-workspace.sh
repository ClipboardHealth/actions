TFC_URL_PREFIX="https://app.terraform.io/api/v2"
TFC_WORKSPACES_URL="${TFC_URL_PREFIX}/organizations/clipboard-staffing/workspaces"
HEADERS= <<EOF
--header "Authorization: Bearer ${TERRAFORM_TOKEN}"
--header "Content-Type: application/vnd.api+json"
EOF

# Create a new workspace
cat <<EOF >new_workspace.json
{"data": {
  "type": "workspaces",
  "attributes": {"name": "${SERVICE_NAME}-${ENVIRONMENT_NAME}"}
}}
EOF
curl $HEADERS --request POST -d @new_workspace.json "$TFC_WORKSPACES_URL"

# Get workspace id
TFC_GET_WORKSPACE_URL="${TFC_WORKSPACES_URL}/${SERVICE_NAME}-${ENVIRONMENT_NAME}"
WORKSPACE_ID=$(curl $HEADERS ${TFC_GET_WORKSPACE_URL} | jq -r ".[].id")

# Add tags to the workspace
cat <<EOF >add_tag_json.json
{"data": [
  {"type": "tags", "attributes": {"name": "${TF_WORKSPACE}"}},
  {"type": "tags", "attributes": {"name": "${SERVICE_NAME}"}}
]}
EOF
TFC_ADD_TAG_URL="${TFC_URL_PREFIX}/workspaces/${WORKSPACE_ID}/relationships/tags"
curl $HEADERS --request POST -d @add_tag_json.json $TFC_ADD_TAG_URL
