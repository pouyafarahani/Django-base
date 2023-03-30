# Build Stage
FROM python:3.9-alpine as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY requirements.txt /code/
RUN apk add --no-cache gcc musl-dev && \
    pip wheel --no-cache-dir --no-deps --wheel-dir /code/wheels -r requirements.txt && \
    apk del gcc musl-dev

COPY . /code/

# Runtime Stage
FROM python:3.9-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

RUN apk add --no-cache libpq
COPY --from=builder /code/wheels /wheels
COPY --from=builder /code /code

RUN pip install --no-cache /wheels/*

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
