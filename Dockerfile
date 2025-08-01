FROM python:3.9-alpine3.16

WORKDIR /service

# Скопировать requirements туда, откуда будем ставить
COPY requirements.txt /tmp/requirements.txt
# Скопировать код
COPY service /service

# Обновить pip и установить зависимости
RUN python -m pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Создать пользователя (Alpine: -D для без пароля)
RUN adduser -D service-user

USER service-user

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
