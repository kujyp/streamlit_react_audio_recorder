FROM python:3.10-slim-bullseye as base

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]

ENV POETRY_HOME="/opt/poetry" \
    POETRY_VERSION=1.6.0 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    SETUP_PATH="/opt/setup" \
    VENV_PATH="/opt/setup/.venv" \
    PIP_NO_CACHE_DIR=false

RUN apt update \
 && apt install -y curl \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

WORKDIR $SETUP_PATH
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN poetry install --no-dev --no-root
RUN poetry install --no-root
RUN playwright install --with-deps

COPY streamlit_react_audio_recorder streamlit_react_audio_recorder



FROM node:21.4-bullseye-slim as frontend
WORKDIR /frontend

COPY streamlit_react_audio_recorder/frontend/package.json package.json
COPY streamlit_react_audio_recorder/frontend/yarn.lock yarn.lock

RUN yarn install
COPY streamlit_react_audio_recorder/frontend/tsconfig.json tsconfig.json
COPY streamlit_react_audio_recorder/frontend/public public
COPY streamlit_react_audio_recorder/frontend/src src
RUN yarn run build

ENV PORT=3001
EXPOSE 3001

CMD yarn run start


FROM base as e2e

COPY e2e e2e
COPY pytest.ini pytest.ini

RUN sed -i 's/_RELEASE = False/_RELEASE = True/' streamlit_react_audio_recorder/__init__.py
COPY --from=frontend /frontend/build streamlit_react_audio_recorder/frontend/build

CMD pytest -vvv e2e
