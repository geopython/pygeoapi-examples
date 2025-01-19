# =================================================================

# Authors: Tom Kralidis <tomkralidis@gmail.com>
#
# Copyright (c) 2024 Tom Kralidis
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# =================================================================


import logging
from http import HTTPStatus
from typing import Tuple

from pygeoapi.util import to_json

from . import APIRequest, API, F_JSON, SYSTEM_LOCALE

LOGGER = logging.getLogger(__name__)

CONFORMANCE_CLASSES = [
    'http://www.opengis.net/spec/ogcapi-newapi-1/1.0/conf/core'
]


def my_function(api: API, request: APIRequest) -> Tuple[dict, int, str]:
    """
    Returns a sample function

    :param request: A request object

    :returns: tuple of headers, status code, content
    """

    format_ = request.format or F_JSON

    # Force response content type and language (en-US only) headers
    headers = request.get_response_headers(SYSTEM_LOCALE, **api.api_headers)

    data = {
        'name': 'my new function!'
    }

    if format_ == F_JSON:
        headers['Content-Type'] = 'application/json'
        return headers, HTTPStatus.OK, to_json(data, api.pretty_print)
    else:
        return api.get_format_exception(request)


def get_oas_30(cfg: dict, locale: str) -> tuple[list[dict[str, str]], dict[str, dict]]:  # noqa
    """
    Get OpenAPI fragments

    :param cfg: `dict` of configuration
    :param locale: `str` of locale

    :returns: `tuple` of `list` of tag objects, and `dict` of path objects
    """

    from pygeoapi.openapi import OPENAPI_YAML

    LOGGER.debug('Setting up newapi endpoint')

    paths = {}

    path = f'/my-function'
    paths[path] = {
        'get': {
            'summary': 'Get my function',
            'description': 'Description of my function',
            'tags': ['newapi'],
            'operationId': 'getMyFunction',
            'parameters': [
                {'$ref': '#/components/parameters/lang'},
                {'$ref': '#/components/parameters/f'}
            ],
            'responses': {
                '200': {'$ref': f"{OPENAPI_YAML['oapif-1']}#/components/responses/Features"},  # noqa
                '400': {'$ref': f"{OPENAPI_YAML['oapif-1']}#/components/responses/InvalidParameter"},  # noqa
                '404': {'$ref': f"{OPENAPI_YAML['oapif-1']}#/components/responses/NotFound"},  # noqa
                '500': {'$ref': f"{OPENAPI_YAML['oapif-1']}#/components/responses/ServerError"}  # noqa
            }
        }
    }

    return [{'name': 'newapi'}], {'paths': paths}
