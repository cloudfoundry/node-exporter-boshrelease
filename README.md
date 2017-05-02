# Prometheus Node Exporter BOSH Release

This is a [BOSH](http://bosh.io/) release for the [Prometheus Node Exporter](https://github.com/prometheus/node_exporter).

It is intented to be deployed as a [BOSH Addon](http://bosh.io/docs/runtime-config.html#addons) and alongside the [Prometheus BOSH Release](https://github.com/cloudfoundry-community/prometheus-boshrelease).

## Usage

To use this BOSH release, first upload it to your BOSH:

```
$ bosh target <YOUR_BOSH_HOST>
$ bosh upload release https://github.com/cloudfoundry-community/node-exporter-boshrelease/releases/download/v1.1.0/node-exporter-1.1.0.tgz
```

Then create a runtime configuration file:

```
releases:
 - name: node-exporter
   version: 1.1.0

addons:
  - name: node_exporter
    jobs:
      - name: node_exporter
        release: node-exporter
    include:
      stemcell:
        - os: ubuntu-trusty
    properties: {}
```

Now you can update your [BOSH Runtime Config](http://bosh.io/docs/runtime-config.html) with the previously created file:

```
$ bosh update runtime-config <your runtime-config.yaml file location>
```

Once runtime config is updated it will applied to all new deployments (the existing deployments will be considered outdated and they will be update when they are deployed again).

## Contributing

Refer to [CONTRIBUTING.md](https://github.com/cloudfoundry-community/node-exporter-boshrelease/blob/master/CONTRIBUTING.md).

## License

Apache License 2.0, see [LICENSE](https://github.com/cloudfoundry-community/node-exporter-boshrelease/blob/master/LICENSE).
