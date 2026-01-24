# Demo Health Service
Spring Boot + Docker + Kubernetes (Portfolio Project)

## 📌 Описание проекта
Учебно-практический проект, имитирующий реальный production-подход к разработке и деплою backend-сервиса.

Цель проекта:
- показать умение работать с **Git workflow**
- контейнеризировать сервис с помощью **Docker**
- развернуть сервис в **Kubernetes**
- использовать стандартные Kubernetes-объекты (Deployment, Service, ConfigMap)
- обеспечить масштабирование и отказоустойчивость **без изменения кода приложения**

Проект оформлен так, чтобы его можно было использовать как **портфолио Junior Java Backend Engineer**.

---

## 🧱 Стек технологий
- Java 21
- Spring Boot 4.0.2
- Maven
- OpenAPI 3 (Swagger UI)
- Docker
- Kubernetes
- GitHub

---

## 🌳 Git workflow
Используется классический production-подход:

- `master` — production
- `test` — staging / pre-prod
- `feature/*` — разработка фич

Правила:
1. Новая функциональность разрабатывается в `feature/*`
2. Merge через Pull Request → `test`
3. Релиз: Pull Request `test` → `master`
4. Прямые коммиты в `master` запрещены

Используются **Conventional Commits**:
- `feat: ...`
- `fix: ...`
- `chore: ...`
- `docs: ...`

---

## 🚀 Этап 1 — Docker

### Требования
- HTTP-сервис
- Endpoint: `/health`
- Возвращает:
  - статус сервиса
  - имя сервиса
- Stateless
- Порт и имя сервиса задаются через переменные окружения
- Один Docker-образ должен запускаться:
  - с разными портами
  - с разными именами сервиса
  - без изменения кода

### Переменные окружения
| Переменная | Назначение |
|-----------|-----------|
| SERVICE_NAME | Имя сервиса |
| SERVICE_PORT | Порт, на котором работает сервис |

---

### Сборка Docker-образа
```bash
docker build -t demo-health-service:1.0 .
````

### Запуск контейнера

```bash
docker run --rm \
  -p 8081:8081 \
  -e SERVICE_NAME=service-a \
  -e SERVICE_PORT=8081 \
  demo-health-service:1.0
```

Проверка:

```bash
curl http://localhost:8081/health
```

Пример ответа:

```json
{
  "status": "UP",
  "service": "service-a",
  "timestamp": "2026-01-24T10:15:30Z"
}
```

---

## ☸️ Этап 2 — Kubernetes

### Требования

* 2 реплики pods для одного сервиса
* Доступность извне через NodePort
* Изменение имени сервиса через ConfigMap
* Автоматическое восстановление pods
* Код приложения **не изменяется** для масштабирования

---

## 📦 Kubernetes объекты

### ConfigMap

Используется для передачи имени сервиса и порта:

```yaml
SERVICE_NAME
SERVICE_PORT
```

Изменение ConfigMap **не требует пересборки Docker-образа**.

---

### Deployment

* `replicas: 2`
* Автоматическое восстановление pods
* Liveness и Readiness probes
* Переменные окружения берутся из ConfigMap

---

### Service (NodePort)

* Тип: `NodePort`
* Открывает сервис наружу
* Позволяет обращаться к сервису по адресу:

```
http://<NODE_IP>:<NODE_PORT>/health
```

---

## 📂 Структура проекта

```
.
├── Dockerfile
├── README.md
├── pom.xml
├── src/
│   └── main/
│       ├── java/...
│       └── resources/
│           └── application.yml
└── k8s/
    ├── configmap.yaml
    ├── deployment.yaml
    └── service.yaml
```

---

## ▶️ Развёртывание в Kubernetes

### Применение манифестов

```bash
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### Проверка pods

```bash
kubectl get pods -l app=demo-health
```

### Проверка сервиса

```bash
kubectl get svc demo-health-nodeport
```

Запрос:

```bash
curl http://<NODE_IP>:30080/health
```

---

## ♻️ Проверка авто-восстановления

```bash
kubectl delete pod <pod-name>
kubectl get pods -l app=demo-health -w
```

Deployment автоматически создаст новый pod.

---

## 🔄 Изменение имени сервиса без пересборки образа

```bash
kubectl edit configmap demo-health-config
```

После изменения:

```bash
kubectl rollout restart deployment demo-health
```

Проверка:

```bash
curl http://<NODE_IP>:30080/health
```

Имя сервиса изменится, Docker-образ останется тем же.

---

## 📖 OpenAPI / Swagger

* Swagger UI:

```
/swagger-ui.html
```

* OpenAPI spec:

```
/v3/api-docs
```

---

## 🎯 Что демонстрирует проект

* Понимание Docker и Kubernetes
* Stateless-подход
* Конфигурацию через env и ConfigMap
* Масштабирование без изменения кода
* Production Git workflow
* Готовность к CI/CD и cloud-native архитектуре

---

## 👤 Автор

Nurlubai Daulet - 
Junior Software Engineer
(Java 21 / Spring Boot 4.0.2 / Docker / Kubernetes)
