FROM python:3-alpine as base

ARG PYPI_SERVER="pypi.org"
ARG PYPI_INDEX="https://$PYPI_SERVER/simple/"
ARG GITHUB_CREDENTIALS

ENV PYPI_SERVER ${PYPI_SERVER}
ENV PYPI_INDEX ${PYPI_INDEX}

ENV HOME /root/
ENV PIPSI_HOME /usr/local/pipsi/environments
ENV PIPSI_BIN_DIR /usr/local/bin
ENV BACKEND_VERSION '0.1a'


RUN apk add --no-cache  \
    postgresql-dev

RUN apk add --no-cache --virtual .build-deps \
    curl \
    gcc \
    python3-dev \
    musl-dev


RUN mkdir -p /root/.local/bin

RUN pip install -U pip \
    && curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python \
    && pip install virtualenv \
    && pipsi install pipenv

RUN mkdir -p /usr/local/sir
WORKDIR /usr/local/src/sir
RUN echo curl -L -u ${GITHUB_CREDENTIALS} "https://github.com/unicef/sir-poc/tarball/${BACKEND_VERSION}"
RUN curl -L -u ${GITHUB_CREDENTIALS} "https://github.com/unicef/sir-poc/tarball/${BACKEND_VERSION}" | tar -xzf - --strip-components=1 \
    && pipenv install --system --deploy --pypi-mirror ${PYPI_INDEX}\
    && pip install .

FROM python:3-alpine
ENV DJANGO_SETTINGS_MODULE sir.config.settings.default
ENV PYTHONUNBUFFERED 1
COPY --from=builder /usr/local/src/sir /usr/local/src/sir
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /usr/local/lib/ /usr/local/lib/
COPY --from=builder /usr/lib/ /usr/lib/

WORKDIR /var/sir
RUN mkdir -p /var/sir/

VOLUME /var/sir/

ADD docker/entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sir"]
