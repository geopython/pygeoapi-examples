FROM geopython/pygeoapi:latest

RUN cp tests/data/open.canada.ca/sample-records.tinydb /sample-records.tinydb
RUN /venv/bin/python3 -m pip install "gunicorn<24" "paho-mqtt"
RUN /venv/bin/python3 -m pip install --target /pygeoapi --no-deps --upgrade https://github.com/geopython/pygeoapi/archive/refs/heads/ogcapi-pubsub.zip

COPY pygeoapi.config.yml /pygeoapi/local.config.yml
