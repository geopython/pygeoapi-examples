# pygeoapi with PostgreSQL/PostGIS

These folders contain a Docker Compose configuration necessary to setup a minimal
`pygeoapi` server that uses a local PostgreSQL backend service to publish [Natural Earth - Populated Places](https://www.naturalearthdata.com/downloads/110m-cultural-vectors/110m-populated-places/); the collection is served as both, OGC API - Features and OGC API - Tiles (using the [MVT-postgresql](https://docs.pygeoapi.io/en/latest/data-publishing/ogcapi-tiles.html#mvt-postgresql) plugin).

More information about this provider, including the features it supports, can be found on the [pygeoapi documentation](https://docs.pygeoapi.io/en/latest/data-publishing/ogcapi-tiles.html#mvt-postgresql).

This config is only for local development and testing.

## PostGIS

This docker composition uses the latest [postgis/postgis](https://hub.docker.com/r/postgis/postgis/), which is based on the official postgres image.

## Building and Running

To build and run the [Docker compose file](docker-compose.yml) in localhost:

```
docker compose up
```