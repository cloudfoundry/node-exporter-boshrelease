# CI

The CI system has been upgraded:

* uses `bosh2`
* automatically runs `testflight-pr` job on pull requests
* automatically fetches new [`node_exporter` releases](https://github.com/prometheus/node_exporter/releases) and adds as a blob
