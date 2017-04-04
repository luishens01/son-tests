#!/usr/bin/env python

# Work in progress...

import requests
import uuid
import yaml
import time

def send_descriptor(descriptor):
    url = "http://sp.int3.sonata-nfv.eu:4002/catalogues/api/v2/network-services"
    data = descriptor
    headers = {'Content-type': 'application/x-yaml'}
    r = requests.post(url, data=yaml.dump(data), headers=headers)
    print(r.status_code)

with open("resources/nsd.yml", 'r') as stream:
    try:
        # print(yaml.load(stream))
        descriptor = yaml.load(stream)
        descriptor['vendor'] = str(uuid.uuid4())
        descriptor['name'] = str(uuid.uuid4())
        descriptor['version'] = str(uuid.uuid4())
        print(descriptor)
        send_descriptor(descriptor)
    except yaml.YAMLError as exc:
        print(exc)
