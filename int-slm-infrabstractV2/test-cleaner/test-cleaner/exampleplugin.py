"""
Created by Manuel Peuster <manuel@peuster.de>

This is a stupid MANO plugin used for testing.
"""

import logging
import json
import time
import sys
import os
import yaml
import uuid

sys.path.append("../son-mano-base")
from sonmanobase.plugin import ManoBasePlugin

logging.basicConfig(level=logging.INFO)
LOG = logging.getLogger("plugin:test-cleaner")
LOG.setLevel(logging.DEBUG)


class DemoPlugin1(ManoBasePlugin):
    """
    This is a very simple example plugin to demonstrate
    some APIs.

    It does the following:
    1. registers itself to the plugin manager
    2. waits some seconds
    3. requests a list of active plugins from the plugin manager and prints it
    4. de-registers itself
    """

    def __init__(self):
        self.correlation_id = str(uuid.uuid4())
        # call super class to do all the messaging and registration overhead
        super(self.__class__, self).__init__(version="0.1-dev")

    def __del__(self):
        super(self.__class__, self).__del__()

    def declare_subscriptions(self):
        """
        Declare topics to listen.
        """
        # We have to call our super class here
        super(self.__class__, self).declare_subscriptions()
        # Examples to demonstrate how a plugin can listen to certain events:
        self.manoconn.register_async_endpoint(self._on_example_request, "example.plugin.*.request")
        self.manoconn.register_notification_endpoint(self._on_example_notification,"example.plugin.*.notification")
        self.manoconn.subscribe(self.on_infrastructure_adaptor_reply, "infrastructure.service.remove")

    def run(self):
        """
        Plugin logic. Does nothing in our example.
        """
        print('corr_id:'+self.correlation_id)
        time.sleep(30)
        print('Timeout')
        os._exit(1)

    def on_registration_ok(self):
        """
        Event that is triggered after a successful registration process.
        """
        LOG.info("Registration OK.")

    def on_lifecycle_start(self, ch, method, properties, message):
        super(self.__class__, self).on_lifecycle_start(ch, method, properties, message)
        id = os.environ.get("instance_uuid", 'aaaaa-aaaaa-aaaaa-aaaaa')
        LOG.info('Found instance_uuid in ENV: '+ id)
        self.removeService(id)

    def on_infrastructure_adaptor_reply(self, ch, method, properties, message):
        LOG.debug(json.loads(message))
        msg = json.loads(message)
        if 'request_status' in msg.keys() and (properties.correlation_id == self.correlation_id):
            if msg['request_status'] == 'COMPLETED':
                LOG.info('instance removed succesfully')
                os._exit(0)
            else:
                LOG.error('error during service remove')
                os._exit(1)

    def removeService(self,id):
        LOG.info('removing the deployed service: %r' % id)
        vim_message = json.dumps({'instance_uuid':id})
        LOG.debug('sending message:'+vim_message)
        self.manoconn.call_async(self.on_infrastructure_adaptor_reply, 'infrastructure.service.remove',vim_message,correlation_id=self.correlation_id)
        time.sleep(30)



    def callback_print(self, ch, method, properties, message):

        print('correlation_id: ' + str(properties.correlation_id))
        print('message: ' + str(message))

    def _on_example_request(self, ch, method, properties, message):
        """
        Only used for the examples.
        """
        print("Example message: %r " % message)
        return json.dumps({"content" : "my response"})

    def _on_example_request_response(self, ch, method, properties, message):
        """
        Only used for the examples.
        """
        print("Example message: %r " % message)

    def _on_example_notification(self, ch, method, properties, message):
        """
        Only used for the examples.
        """
        print("Example message: %r " % message)

    def parseNsd(self):
        """
        This method helps creating messages for the service request packets.
        """
        LOG.debug("Parsing NSD...")
        path_descriptors = '/test_descriptors/'
    	#import the nsd and vnfds that form the service	
        file = open(path_descriptors + 'sonata-demo.yml','r')
        nsd = yaml.load(file)
        print('hallo')
        LOG.debug(file)
        LOG.debug("NSD parsed")
        LOG.debug(yaml.dump(nsd['instance_uuid']))
        LOG.debug("end of NSD")
        return nsd

    def createInfrastructureAdapterResponseMessage(self):
        path_descriptors = 'test_records/'

        ia_nsr = yaml.load(open(path_descriptors + 'ia-nsr.yml','r'))

        return str(ia_nsr)

    def on_list(self, ch, method, properties, message):
        print(properties)


def main():
    # reduce log level to have a nice output for demonstration
    # reduce messaging log level to have a nicer output for this plugin
    logging.getLogger("son-mano-base:messaging").setLevel(logging.INFO)
    logging.getLogger("son-mano-base:plugin").setLevel(logging.INFO)
    DemoPlugin1()

if __name__ == '__main__':
    main()
