FROM python:3.11-slim

# Запрет записи байт-кода Python в файлы .pyc и отключение буферизации вывода интерпретатора Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY python-random.py ./python-random.py

EXPOSE 8082

CMD ["python3", "/app/python-random.py"]
