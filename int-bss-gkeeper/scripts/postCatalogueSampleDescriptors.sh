#!/bin/bash

# -- insert NSD/VNFD
curl -H "Content-Type: application/json" -X POST --data-binary @int-bss-gkeeper/resources/NSD.json http://sp.int3.sonata-nfv.eu:4002/catalogues/network-services
curl -H "Content-Type: application/json" -X POST --data-binary @int-bss-gkeeper/resources/VNFD.json http://sp.int3.sonata-nfv.eu:4002/catalogues/vnfs