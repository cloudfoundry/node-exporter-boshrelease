# Prometheus Node Exporter BOSH Release

This is a [BOSH](http://bosh.io/) release for the [Prometheus Node Exporter](https://github.com/prometheus/node_exporter) for Linux based stemcells.

It is intented to be deployed as a [BOSH Addon](http://bosh.io/docs/runtime-config.html#addons) and alongside the [Prometheus BOSH Release](https://github.com/bosh-prometheus/prometheus-boshrelease).

## Usage

To use this BOSH release, first upload it to your BOSH:

```
export BOSH_ENVIRONMENT=<name>
bosh upload-release https://github.com/cloudfoundry/node-exporter-boshrelease/releases/download/v5.0.0/node-exporter-5.0.0.tgz
```

Then create a runtime configuration file:

```
releases:
  - name: node-exporter
    version: 5.0.0

addons:
  - name: node_exporter
    jobs:
      - name: node_exporter
        release: node-exporter
    include:
      stemcell:
        - os: ubuntu-trusty
        - os: ubuntu-xenial
    properties: {}
```

Now you can update your [BOSH Runtime Config](http://bosh.io/docs/runtime-config.html) with the previously created file:

```
bosh update-runtime-config <your runtime-config.yaml file location>
```

Once runtime config is updated it will applied to all new deployments (the existing deployments will be considered outdated and they will be update when they are deployed again).

## Contributing

Refer to [CONTRIBUTING.md](https://github.com/cloudfoundry/node-exporter-boshrelease/blob/master/CONTRIBUTING.md).

## Run tests

```sh
$ docker run -ti --rm -v$(pwd):/repo ruby:3.2 /bin/bash
# cd /repo/spec
# bundler install
# bundle exec rspec .
```

## License

Apache License 2.0, see [LICENSE](https://github.com/cloudfoundry/node-exporter-boshrelease/blob/master/LICENSE).
