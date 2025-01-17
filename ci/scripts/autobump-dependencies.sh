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
  echo "TODO: Add upload blobs"
  export GH_TOKEN=${GITHUB_COM_TOKEN}
  cd git
  branch_name="node_exporter-auto-bump-master"
  existing_prs="$(gh pr list --head $branch_name --json)"
  if [ ${#key[@]} == 0 ]; then
    git checkout -b $branch_name
    git config user.name "$BOT_USER_NAME"
    git config user.email "$BOT_USER_MAIL"
    git add config/blobs.yml
    git commit --author="${BOT_USER_NAME} <${BOT_USER_MAIL}>" -m "Bump node_exporter version to 1.8.2"
    git add packages/node_exporter
    git commit --author="${BOT_USER_NAME} <${BOT_USER_MAIL}>" -m "Update blob reference for node_exporter to version 1.8.2"
    git push origin -u $branch_name
    gh pr create --base $PR_BASE --head $branch_name --title "Bump node_exporter version to 1.8.2" --body "Automatic bump from version 1.8.1 to version 1.8.1, downloaded from https://github.com/prometheus/node_exporter/releases/tag/v1.8.2.\nAfter merge, consider releasing a new version of node-exporter-boshrelease." --label $PR_LABEL
  else
    echo "A PR already exists"
  fi
else
  echo "DRY_RUN: bosh upload-blobs --sha2"
  echo "TODO Create PR"
fi

rm -rf /tmp/cache/ /tmp/prometheus-blobs/
