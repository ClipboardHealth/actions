# Clipboard Health shared Github Actions

You can find in this repository, all shared actions to do the most variables
tasks, like build, lint, deploy and other stuff.

If you think on copy and paste some github actions, please, think again and
share your code with the hole company.

## Usage

You can see all available actions in `workflows` path.

```yml
jobs:
  - uses: ClipboardHealth/actions/workflows/desired-workflow
  with:
    some_input_parameter_1: parameter_value_1
    some_other_input_parameter: ${{ env.YOUR_VARIABLE }}
  secrets:
    some_input_secret: "${{ secrets.YOUR_STORED_SECRET }}"
```
