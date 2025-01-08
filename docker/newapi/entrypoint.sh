#!/bin/sh

# Copy the configuration file
cp pygeoapi-config.yml /pygeoapi/example-config.yml

# Generate the OpenAPI documentation
pygeoapi openapi generate /pygeoapi/local.config.yml --output-file /pygeoapi/local.openapi.yml

# Start the Flask application
exec python3 flask_app.py
