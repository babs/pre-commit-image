# pre-commit-image

This repo monitors [`pre-commit`](https://pre-commit.com/) releases then build and publish a Python 3.14 Debian trixie slim docker image available at:

* GitHub Container Registry:
```
ghcr.io/babs/pre-commit-image:latest
```

* Quay.io
```
quay.io/beardedbabs/pre-commit-image:latest
```

* Docker hub
```
beardedbabs/pre-commit-image:latest
```

`-node` tags (`latest-node`, `<version>-node`) add the Node.js LTS from [NodeSource](https://github.com/nodesource/distributions), current at build time; pre-commit `language: node` hooks then use it instead of downloading Node.
