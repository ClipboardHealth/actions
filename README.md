# CBH shared Github Actions

You can find in this repository, all shared actions to do the most variables
tasks, like build, lint, deploy and other stuff.

If you tought on copy and paste some github actions, please, think again and
share your code with everyone on Clipboard Health.

## Usage

You can see all available actions in `workflows` path.

```yml
jobs:
  - uses: ClipboardHealth/actions/.github/actions/desired-workflow
  with:
    some_input_parameter_1: parameter_value_1
    some_other_input_parameter: ${{ env.YOUR_VARIABLE }}
  secrets:
    some_input_secret: "${{ secrets.YOUR_STORED_SECRET }}"
```

## Contributing

Please install in your machine:

- [pre-commit](https://pre-commit.com)
- [actionlint](https://github.com/rhysd/actionlint/blob/main/docs/install.md)

After clone, please activate pre-commit:

```shell
pre-commit install
```

Now you can create your actions on `.github/actions` folder.
