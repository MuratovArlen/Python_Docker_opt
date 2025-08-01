FROM python:3.9-alpine3.16

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /service

# Установить только то, что нужно для работы с Postgres (клиент)
RUN apk update && apk add --no-cache postgresql-client

# Скопировать requirements и поставить зависимости
COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Скопировать код
COPY service /service

# Создать пользователя и дать права
RUN adduser -D service-user && chown -R service-user:service-user /service
USER service-user

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
