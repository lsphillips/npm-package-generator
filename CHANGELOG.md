# Changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.1.0 - 2023-06-04

### Added

- Introduced an `.nvmrc` file which will state the latest of the configured Node versions.

### Changed

- Updated the `.npmrc` file to configure `engine-strict` to `true`.

## 2.0.0 - 2023-04-24

### Added

- Introduced the `is_cli_package` option. This option will cause the module to setup a package that includes a CLI executable to be installed into the PATH.

### Changed

- Renamed the `is_browser_compatible` option to `is_browser_package`.
- Renamed the `is_node_compatible` option to `is_node_package`.

## 1.0.0 - 2023-04-03

The initial public release.
