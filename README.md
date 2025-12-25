# HW24 — Kubernetes + Docker (Python random string)

Це ДЗ: зібрати Docker-образ з Python-скриптом, запушити його у **приватний** Docker Hub репозиторій, розгорнути в Kubernetes через Deployment, підняти Service, підключитися до сервісу та перевірити, що трафік розподіляється між різними pod-ами.

## Вимоги (коротко)

- Docker image з Python-скриптом, який повертає випадковий рядок
- Push image у **Private** Docker Hub repo
- Kubernetes: Deployment + Service
- Перевірка запитами (curl/браузер)
- Доказ балансування між pod-ами

## Документація

1) Docker (репозиторій, білд, пуш, скріни): [DOCKER_STEPS.md](DOCKER_STEPS.md)
2) Kubernetes (kind кластер + regcred secret + перевірки + скріни): [K8S_CLUSTER_AND_SECRET.md](docs/K8S_CLUSTER_AND_SECRET.md)
3) Kubernetes (Deployment + Service + перевірки балансування + скріни): [K8S_DEPLOYMENT_AND_SERVICE.md](docs/K8S_DEPLOYMENT_AND_SERVICE.md)

## Вміст репозиторію

- `for_HW24/` — Python-скрипт + Dockerfile + скрипт для build/push
- `k8s/` — маніфести Kubernetes (Deployment/Service/Secret тощо)
- `screens/` — скріншоти для здачі
- `task.txt` — текст завдання
