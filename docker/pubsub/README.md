# pygeoapi-pubsub-demo

This demo implements a pygeoapi OGC API - Publish-Subscribe client for both MQTT or HTTP

## Running

```bash
# build
make build
# start pygeoapi, mosquitto and ntfy
make up
# see API
curl http://localhost:9888  # or open in a web browser
curl http://localhost:5003  # open in a web browser
curl "http://localhost:9888/asyncapi?f=json"  # or open in a web browser
curl "http://localhost:9888/asyncapi?f=html"  # open in a web browser
# MQTT server avilable at mqtt://pygeoapi-pubsub-demo:pygeoapi-pubsub-demo@mqtt-broker:1883
# stop all services
make down
```

## Notes

- to adjust between MQTT or HTTP, update `pygeoapi-pubsub-demo.config.yml` (`pubsub` section) and update the deployment with `make build && make up`
