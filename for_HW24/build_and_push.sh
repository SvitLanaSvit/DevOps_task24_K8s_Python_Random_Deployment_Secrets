#!/bin/bash
set -euo pipefail

DOCKERHUB_USERNAME="${DOCKERHUB_USERNAME:-svitlanakizilpinar}"
IMAGE_REPO="${IMAGE_REPO:-python_random_private}"
TAG="${TAG:-1.0}"

IMAGE="${DOCKERHUB_USERNAME}/${IMAGE_REPO}:${TAG}"

if [[ -z "${DOCKERHUB_USERNAME}" || -z "${IMAGE_REPO}" || -z "${TAG}" ]]; then
  echo "ERROR: DOCKERHUB_USERNAME, IMAGE_REPO, and TAG must be non-empty." >&2
  exit 1
fi

echo "==> Building image: ${IMAGE}"
docker build -t "${IMAGE}" .

echo "==> (Optional) Smoke test locally on http://localhost:8082/"

echo "==> Pushing to Docker Hub: ${IMAGE}"
docker push "${IMAGE}"

echo "DONE: ${IMAGE}"
