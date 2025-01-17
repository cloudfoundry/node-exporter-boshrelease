# /bin/bash

sudo mkdir -p -m 755 /etc/apt/keyrings \
&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \

sudo apt update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC sudo apt install jq curl git sed nodejs make wget unzip gh -y
mkdir /tmp/cache /tmp/prometheus-blobs

export BOSH_VERSION=7.6.1

pushd /tmp/cache && curl -sL https://github.com/cloudfoundry/bosh-cli/releases/download/v${BOSH_VERSION}/bosh-cli-${BOSH_VERSION}-linux-amd64 > bosh && chmod 777 bosh

export LATEST_NODE_EXPORTER_DOWNLOAD_URL=$(curl -sL https://cf-prometheus-ci-bot:${CF_PROM_CI_BOT_TOKEN}@api.github.com/repos/prometheus/node_exporter/releases/latest | jq -r '.assets[].browser_download_url' | grep 'linux-amd64.tar.gz$')
echo ${LATEST_NODE_EXPORTER_DOWNLOAD_URL}

export LATEST_NODE_EXPORTER_VERSION=$(curl -sL https://cf-prometheus-ci-bot:${CF_PROM_CI_BOT_TOKEN}@api.github.com/repos/prometheus/node_exporter/releases/latest | jq -r '.tag_name')
echo ${LATEST_NODE_EXPORTER_VERSION}

popd

export USED_NODE_EXPORTER_VERSION=$(cat config/blobs.yml | egrep -o "node_exporter-[[:digit:]]+.[[:digit:]]+.[[:digit:]]+" | cut -d "-" -f 2)
echo ${USED_NODE_EXPORTER_VERSION}

if [[ $LATEST_NODE_EXPORTER_VERSION != $USED_NODE_EXPORTER_VERSION ]]; then
  curl -sL $LATEST_NODE_EXPORTER_DOWNLOAD_URL -o /tmp/cache/node_exporter-$LATEST_NODE_EXPORTER_VERSION.linux-amd64.tar.gz
  /tmp/cache/bosh add-blob /tmp/cache/node_exporter-$LATEST_NODE_EXPORTER_VERSION.linux-amd64.tar.gz node_exporter/node_exporter-$LATEST_NODE_EXPORTER_VERSION.linux-amd64.tar.gz
  /tmp/cache/bosh remove-blob node_exporter/node_exporter-$USED_NODE_EXPORTER_VERSION.linux-amd64.tar.gz
fi

/tmp/cache/bosh blobs

sed -i -e "s/node_exporter-$USED_NODE_EXPORTER_VERSION\.linux-amd64/node_exporter-$LATEST_NODE_EXPORTER_VERSION\.linux-amd64/g" packages/node_exporter/*

echo $DRY_RUN

if [ -z "$DRY_RUN" ]; then
  echo "I would have uploaded blobs"
  echo "I would have created a PR"
else
  echo "DRY_RUN: bosh upload-blobs --sha2"
  echo "TODO Create PR"
fi

rm -rf /tmp/cache/ /tmp/prometheus-blobs/
