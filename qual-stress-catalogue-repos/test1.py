#!/usr/bin/env python

# Work in progress...

import requests
import uuid
import yaml
import time

def send_file(package_file):
    url = "http://sp.int3.sonata-nfv.eu:4002/catalogues/api/v2/son-packages"
    data = package_file
    headers = {
        'content-type': "application/zip",
        'content-disposition': "attachment; filename=" + str(uuid.uuid4()),
    }
    r = requests.post(url, data=package_file, headers=headers)
    print(r.status_code)

with open("resources/sonata-demo.son", mode='rb') as file:
    try:
        send_file(file)
    except Exception as e:
        print(e)