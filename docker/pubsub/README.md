# OGC API - Pub/Sub with pygeoapi

This directory contains the necessary components to deploy an MQTT broker and a pygeoapi
instance with OGC API - Pub/Sub enabled.

This example is set up to have communication between the following containers:

    - *Mosquitto*: MQTT Broker that publishes notifications.
    - *pygeoapi*: Publishes MQTT notifications through the docker network to the broker

To run:

```bash
docker compose up -d --build
```
