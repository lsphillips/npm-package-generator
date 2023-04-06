# `npm-package-repository`

A Terraform module that enables you to quickly create a NPM package repository following all _my_ opinionated conventions.

## Usage

This module uses the [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs), therefore access needs to be granted by configuring a `GITHUB_TOKEN` environment variable with a token with the following **classic** scopes:

- `repo`
- `delete_repo` _(optional)_

This modules also requires `node` (and `npm`) to be installed in order to generate an initial `package-lock.json` file.

### Using as a module

Create a `main.tf` file and utilize like any normal module:

``` tf
module "test_package_repository" {
    source       = "git@github.com:lsphillips/npm-package-generator.git"
    package_name = "test-package"
    author_name  = "Luke Phillips"
    author_email = "lsphillips.projects@gmail.com"
}

output "repository_url" {
    value = module.test_package_repository.package_repository_url
}
```

You can see a more complete example [here](example/test-package.tf).

### Using via the CLI

You can also clone this repository and use the Terraform CLI:

```
terraform apply \
    -var package_name="test-package" \
    -var author_name="Luke Phillips" \
    -var author_email="lsphillips.projects@gmail.com"
```

### Options

| Variable                  | Type           | Required | Default    | Description                                                                                             |
| ------------------------- | :------------: | :------: | :--------: | ------------------------------------------------------------------------------------------------------- |
| `package_name`            | `string`       | **Yes**  |            | The name of the package being produced.                                                                 |
| `package_description`     | `string`       | **No**   |            | A short description describing the package.                                                             |
| `is_browser_compatible`   | `bool`         | **No**   | `true`     | Indicates whether the package is compatible with a web browser environment.                             |
| `is_node_compatible`      | `bool`         | **No**   | `true`     | Indicates whether the package is compatible with a NodeJS environment.                                  |
| `supported_node_versions` | `list(number)` | **No**   | `[16, 18]` | A list of NodeJS versions that the package supports. Only applicable if `is_node_compatible` is `true`. |
| `author_name`             | `string`       | **Yes**  |            | The name of the author of the package.                                                                  |
| `author_email`            | `string`       | **Yes**  |            | The email address for the author of the package. This will be public!                                   |
| `is_public`               | `bool`         | **No**   | `false`    | Indicates if the package is to be public.                                                               |

### Outputs

| Output                   | Type     | Description                                                                 |
| ------------------------ | :------: | --------------------------------------------------------------------------- |
| `package_repository_url` | `string` | The URL of the repository that can be used to clone the package repository. |

## Manual Actions

Once the package repository is created you will still need to make the following manual actions:

- Enable the `Allow GitHub Actions to create and approve pull requests` setting under `Settings > Actions > General`. This will ensure select Dependabot pull requests can be automatically approved and merged.
- Remove all issue labels accept for the `bug` and `dependencies` tag.

## License

This project is released under the [MIT license](LICENSE.txt).
