# Clipboard health terraform action

<!-- action-docs-description -->
## Description

Creates terraform workspace


<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| - | - | - | - |
| SERVICE_NAME | The service, usually repo name | `true` |  |
| ENVIRONMENT_NAME | Environment name can be (production, staging, development, gamma-XXX) | `true` |  |
| TERRAFORM_TAG_LIST | A comma-separated list of desired tags | `true` |  |
| TERRAFORM_PATH | Location of terraform files in this repo | `true` | terraform |
| TERRAFORM_TOKEN | Terraform Cloud Token | `true` |  |
| TERRAFORM_VAR_PATH | A path to .tfvars file. | `false` |  |
| PLAN_ONLY | Should only run Terraform plan, without applying? | `false` |  |



<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is an `composite` action.


<!-- action-docs-runs -->
