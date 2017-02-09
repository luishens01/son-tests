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
    2. send a service remove reques to the IA
    3. wait for the response and parse it
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

    def run(self):
        """
        Plugin logic. Does nothing in our example.
        """
        LOG.info('corr_id:'+self.correlation_id)
        time.sleep(120)
        LOG.info('Timeout')
        self.deregister()
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
        if 'status' in msg.keys() and (properties.correlation_id == self.correlation_id):
            if msg['status'] == 'SUCCESS':
                LOG.info('instance removed succesfully')
                self.deregister()
                os._exit(0)
            else:
                LOG.error('error during service remove')
                self.deregister()
                os._exit(1)

    def removeService(self,id):
        LOG.info('removing the deployed service: %r' % id)
        vim_message = json.dumps({'instance_uuid':id})
        LOG.debug('sending message:'+vim_message)
        self.manoconn.call_async(self.on_infrastructure_adaptor_reply, 'infrastructure.service.remove',vim_message,correlation_id=self.correlation_id)
        time.sleep(30)



    def callback_print(self, ch, method, properties, message):

        LOG.info('correlation_id: ' + str(properties.correlation_id))
        LOG.info('message: ' + str(message))

    def _on_example_request(self, ch, method, properties, message):
        """
        Only used for the examples.
        """
        LOG.info("Example message: %r " % message)
        return json.dumps({"content" : "my response"})

    def _on_example_request_response(self, ch, method, properties, message):
        """
        Only used for the examples.
        """
        LOG.info("Example message: %r " % message)

    def _on_example_notification(self, ch, method, properties, message):
        """
        Only used for the examples.
        """
        LOG.info("Example message: %r " % message)

    def on_list(self, ch, method, properties, message):
        LOG.info(properties)


def main():
    # reduce log level to have a nice output for demonstration
    # reduce messaging log level to have a nicer output for this plugin
    logging.getLogger("son-mano-base:messaging").setLevel(logging.INFO)
    logging.getLogger("son-mano-base:plugin").setLevel(logging.INFO)
    DemoPlugin1()

if __name__ == '__main__':
    main()
