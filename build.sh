#! /bin/bash
set -e
docker run --rm -i hadolint/hadolint < Dockerfile
docker build --pull . -t nts_nys_traffic_routing:latest
docker run --rm -v ${HOME}/.cache/:/root/.cache/ -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --clear-cache
docker run --rm -v ${HOME}/.cache/:/root/.cache/ -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 1 --ignore-unfixed --no-progress nts_nys_traffic_routing:latest
echo done
