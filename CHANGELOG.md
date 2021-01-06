# Changelog

We document all notable changes to the project in the file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [semantic versioning](http://semver.org/).

# Release Notes
## [Unreleased](https://github.com/algolia/frontman/compare/0.1.1...master)

## [0.1.1](https://github.com/algolia/frontman/tree/0.1.1) - 2021-01-05
### Fixed
* Empty buffer bug when using a nested `content_for` block in HAML templates ([`#43`](https://github.com/algolia/frontman/pull/43))

## [0.1.0](https://github.com/algolia/frontman/tree/0.1.0) - 2021-01-05

### Added
* Support for Slim templates ([`#41`](https://github.com/algolia/frontman/pull/41)) by [@westonganger](https://github.com/westonganger)
* `append_content` method to push content to a block ([`#25`](https://github.com/algolia/frontman/pull/25)) by [@westonganger](https://github.com/westonganger)
* Setting to change the local server host ([`#36`](https://github.com/algolia/frontman/pull/36)) by [@westonganger](https://github.com/westonganger)
* Execute Rubocop in the default Rake task ([`#37`](https://github.com/algolia/frontman/pull/37)) by [@westonganger](https://github.com/westonganger)

### Fixed
* Issue with setting for local server ports ([`#42`](https://github.com/algolia/frontman/pull/42)) by [@westonganger](https://github.com/westonganger)

## [0.0.4](https://github.com/algolia/frontman/tree/0.0.4) - 2020-08-28

### Added
* Retry strategy to allow for multiple running Frontman processes ([`#24`](https://github.com/algolia/frontman/pull/24)) by [@westonganger](https://github.com/westonganger)
* Added `--force` flag to the `frontman init` command ([`#29`](https://github.com/algolia/frontman/pull/29)) by [@MikeRogers0](https://github.com/MikeRogers0)
* Improved data directory registration ([`#30`](https://github.com/algolia/frontman/pull/30)) by [@westonganger](https://github.com/westonganger)
* `import_config` method to easily load multiple configuration files ([`#34`](https://github.com/algolia/frontman/pull/34)) by [@westonganger](https://github.com/westonganger)

### Fixed
* Added `https://rubygems.org` as a source for our dependencies ([`#32`](https://github.com/algolia/frontman/pull/32)) by [@MikeRogers0](https://github.com/MikeRogers0)

## [0.0.3](https://github.com/algolia/frontman/tree/0.0.3) - 2020-08-28

### Added
* Documentation on the release process.
* Load possible `.env` files before application bootstrapping.
* Asset fingerprinting through configuration.

### Security
* Update dependencies in the Webpack project template.

### Fixed
* Prevent `DataStoreFile` from being converted to `OpenStruct`.
* Misc. updates to the projects documentation.

## [0.0.2](https://github.com/algolia/frontman/tree/0.0.2)
The initial alpha release.

