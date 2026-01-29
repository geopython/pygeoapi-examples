FROM geopython/pygeoapi:latest

RUN /venv/bin/python3 -m pip install -r /pygeoapi/requirements-pubsub.txt

COPY pygeoapi.config.yml /pygeoapi/local.config.yml
