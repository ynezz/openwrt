# Content

This directory contains stuff used on the GitLab CI.

## docker

Contains definitions for Docker images.

## testbed

Contains definitions for testbed related tests.

## scripts

Contains scripts used on GitLab CI.

## tests

Contains tests used on GitLab CI.

## docker.yml

Provides support for building, tagging and pushing the Docker images to image registry.

For example let's build image `foo`.

Prerequisites:

 * Create directory for new Docker image `mkdir -p .gitlab/docker/foo`
 * Docker image description `$EDITOR .gitlab/docker/foo/Dockefile`

Then just put following into `.gitlab/docker/foo/gitlab.yml`

```yaml
build Docker image foo:
  extends: .build Docker image
```

## testbed.yml

Provides bits needed for runtime testing on real device using [labgrid](https://labgrid.readthedocs.io/en/latest/) Python testing framework.
