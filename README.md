# GitHub Actions Runner, Krystal-flavored

This is a customized version of the official
[actions/runner](https://github.com/actions/runner) container image, primarily
intended for use with
[ARC](https://github.com/actions/actions-runner-controller).

Differences from official image:

- Support for using various `setup-*` actions like `ruby/setup-ruby` and
  `actions/setup-go`.
- Support for using `docker compose`/`docker-compose` commands.

## Usage

Customize your runner to use `ghcr.io/krystal/actions-runner:latest` instead or
`ghcr.io/actions/actions-runner:latest`.
