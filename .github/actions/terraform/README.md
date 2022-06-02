# Clipboard health terraform action

<!-- action-docs-description -->
## Description

Creates terraform workspace


<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| - | - | - | - |
| service_name | The service, usually repo name | `true` |  |
| environment_name | Environment name can be (production, staging, development, gamma-XXX) | `true` |  |
| terraform_tag_list | A comma-separated list of desired tags | `true` |  |
| terraform_path | Location of terraform files in this repo | `true` | terraform |
| terraform_token | Terraform Cloud Token | `true` |  |



<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is an `composite` action.


<!-- action-docs-runs -->
