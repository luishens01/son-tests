import json
import requests


def plugin_list(endpoint):
    r = requests.get("%s/api/plugins" % endpoint)
    if r.status_code != 200:
        _request_failed(r.status_code)
    return r.json()


def plugin_info(uuid, endpoint):
    r = requests.get("%s/api/plugins/%s" % (endpoint, uuid))
    if r.status_code != 200:
        _request_failed(r.status_code)
    return r.json()


def plugin_remove(uuid, endpoint):
    r = requests.delete("%s/api/plugins/%s" % (endpoint, uuid))
    if r.status_code != 200:
        _request_failed(r.status_code)
    return r.json()
