### Локальная отладка

uvicorn app:app --port 8080 --reload

### Сборка образа

docker build -t shorturl_service:1.0.0 .

### Запуск сервиса

docker run -p 8000:80 -v ./data:/app/data shorturl_service:1.0.0
