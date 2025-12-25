#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional env file (recommended): keep secrets out of shell history.
ENV_FILE="${ENV_FILE:-${SCRIPT_DIR}/.env}"
if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
fi

CLUSTER_NAME="${CLUSTER_NAME:-python-random-cluster}"
KIND_CONFIG="${KIND_CONFIG:-${SCRIPT_DIR}/kind-config.yaml}"

# Docker Hub / registry secret settings
SECRET_NAME="${SECRET_NAME:-regcred}"
DOCKER_SERVER="${DOCKER_SERVER:-https://index.docker.io/v1/}"
DOCKERHUB_USERNAME="${DOCKERHUB_USERNAME:-svitlanakizilpinar}"
DOCKERHUB_EMAIL="${DOCKERHUB_EMAIL:-}"
DOCKERHUB_PAT="${DOCKERHUB_PAT:-}"

echo "==> Ensuring kind cluster: ${CLUSTER_NAME}"
if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  kind create cluster --name "${CLUSTER_NAME}" --config "${KIND_CONFIG}"
fi

echo "==> Using kubectl context: kind-${CLUSTER_NAME}"
kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

echo "==> Waiting for nodes to be Ready"
kubectl wait --for=condition=Ready nodes --all --timeout=180s

echo "==> Ensuring Docker registry secret (imagePullSecret): ${SECRET_NAME}"
if kubectl get secret "${SECRET_NAME}" >/dev/null 2>&1; then
  echo "==> Secret already exists; skipping create/apply"
else
  if [[ -z "${DOCKERHUB_EMAIL}" || -z "${DOCKERHUB_PAT}" ]]; then
    echo "ERROR: Set DOCKERHUB_EMAIL and DOCKERHUB_PAT env vars before running." >&2
    echo "Example:" >&2
    echo "  DOCKERHUB_EMAIL=you@example.com DOCKERHUB_PAT=xxxx bash k8s/deploy.sh" >&2
    exit 1
  fi

  SECRET_YAML_PATH="${SCRIPT_DIR}/dockerhub-secret.yaml"

  kubectl create secret docker-registry "${SECRET_NAME}" \
    --docker-server="${DOCKER_SERVER}" \
    --docker-username="${DOCKERHUB_USERNAME}" \
    --docker-password="${DOCKERHUB_PAT}" \
    --docker-email="${DOCKERHUB_EMAIL}" \
    --dry-run=client -o yaml > "${SECRET_YAML_PATH}"

  kubectl apply -f "${SECRET_YAML_PATH}"
fi

echo "==> Applying Deployment/Service"
kubectl apply -f "${SCRIPT_DIR}/deployment.yaml"
kubectl apply -f "${SCRIPT_DIR}/service.yaml"

echo "==> Current objects"
kubectl get deploy,po,svc -o wide

echo "DONE: cluster ready, secret ensured, Deployment/Service applied."
echo "Next (access): kubectl port-forward svc/python-random-service 8082:8082"
echo "Then open/curl: http://localhost:8082"