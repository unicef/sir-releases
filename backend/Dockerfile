FROM python:3-alpine as builder

ARG GITHUB_CREDENTIALS
ARG BACKEND_VERSION

ENV HOME /root/
ENV PIPSI_HOME /usr/local/pipsi/environments
ENV PIPSI_BIN_DIR /usr/local/bin
ENV BACKEND_VERSION $BACKEND_VERSION


RUN apk add --no-cache  \
    postgresql-dev

RUN apk add --no-cache --virtual .build-deps \
    curl \
    gcc \
    python3-dev \
    musl-dev \
    py-pip \
    jpeg-dev \
    zlib-dev

ENV LIBRARY_PATH=/lib:/usr/lib

RUN mkdir -p /root/.local/bin

RUN pip install -U pip \
    && curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python \
    && pip install virtualenv \
    && pipsi install pipenv



RUN mkdir -p /usr/local/sir
WORKDIR /usr/local/src/sir

RUN  curl -u $GITHUB_CREDENTIALS  -L "https://github.com/unicef/sir-poc/archive/${BACKEND_VERSION}.tar.gz" | tar -xzf - --strip-components=1 \
    && pipenv install --system --deploy \
    && pip install .

FROM python:3-alpine

ENV DJANGO_SETTINGS_MODULE sir.config.settings
ENV PYTHONUNBUFFERED 1
ENV SESSION_COOKIE_SECURE 1
ENV CSRF_COOKIE_SECURE 1
ENV DEBUG 0
ENV X_FRAME_OPTIONS DENY
ENV USE_GUNICORN 1

COPY --from=builder /usr/local/src/sir /usr/local/src/sir
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /usr/local/lib/ /usr/local/lib/
COPY --from=builder /usr/lib/ /usr/lib/

WORKDIR /var/sir
RUN mkdir -p /var/sir/

VOLUME /var/sir/

ADD entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sir"]
