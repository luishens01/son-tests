import json
import requests


def plugin_list(endpoint):
    r = requests.get("%s/api/plugins" % endpoint)
    if r.status_code != 200:
        raise BaseException("Plugin list request failed: %r" % r.text)
    return r.json()


def plugin_info(uuid, endpoint):
    r = requests.get("%s/api/plugins/%s" % (endpoint, uuid))
    if r.status_code != 200:
        raise BaseException("Plugin list request failed: %r" % r.text)
    return r.json()


def plugin_remove(uuid, endpoint):
    r = requests.delete("%s/api/plugins/%s" % (endpoint, uuid))
    if r.status_code != 200:
        raise BaseException("Plugin list request failed: %r" % r.text)
    return r.json()
