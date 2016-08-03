import pika
import yaml
import threading
import sys

# The topic to which service instantiation requests
# of the GK are published
SERVICE_CREATE_TOPIC = 'service.instances.create'
# The topic to which available vims are published
INFRA_ADAPTOR_AVAILABLE_VIMS = 'infrastructure.management.compute.list'
# The topic to which service instance deploy replies of the Infrastructure Adaptor are published
INFRA_ADAPTOR_INSTANCE_DEPLOY_REPLY_TOPIC = "infrastructure.service.deploy"


# This method reads the VNFDs and NSD from file and returns a dictionary containing them. The network service
# consists of three network functions: firewall, iperf and tcpdump.
def buildRequest():

    path_descriptors = 'resources/test_descriptors/'

    nsd_descriptor   = open(path_descriptors + 'sonata-demo.yml','r')
    vnfd1_descriptor = open(path_descriptors + 'firewall-vnfd.yml','r')
    vnfd2_descriptor = open(path_descriptors + 'iperf-vnfd.yml','r')
    vnfd3_descriptor = open(path_descriptors + 'tcpdump-vnfd.yml','r')

    service_request = {}
    service_request['NSD'] = yaml.load(nsd_descriptor)
    service_request['VNFD1'] = yaml.load(vnfd1_descriptor)
    service_request['VNFD2'] = yaml.load(vnfd2_descriptor)
    service_request['VNFD3'] = yaml.load(vnfd3_descriptor)

    return yaml.dump(service_request)


# Methiod simulating the GK. It creates a RabbitMQ connection and sends the GK request under the
# 'service.instances.create' topic. After that, it waits for replies with same topic, consuming the
# channels queue.
def send_gk_request():
    request = buildRequest()

    connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
    channel = connection.channel()

    channel.exchange_declare(exchange='son-kernel',
                         type='topic')
    result = channel.queue_declare(exclusive=True)
    queue_name = result.method.queue

    channel.queue_bind(exchange='son-kernel',
                       queue=queue_name,
                       routing_key=SERVICE_CREATE_TOPIC)

    channel.basic_consume(gk_receive,
                      queue=queue_name,
                      no_ack=False)

    channel.basic_publish(exchange='son-kernel', routing_key=SERVICE_CREATE_TOPIC, body=request, properties=pika.BasicProperties(reply_to=queue_name, correlation_id='123213'))

    channel.start_consuming()

# Callback method of the GK called when a message with 'service.instances.create' topic. It waits until the response either:
# - indicates that the network service is deployed: it finishes the script.
# - indicates that there was an error deploying the network service: it finishes the script with an error.
def gk_receive(ch, method, properties, body):

    message = body.decode("utf-8")
    response = yaml.load(message)

    if 'error' in response and 'status' in response and response['status'] == 'READY':
        print ("Test finished.")
        sys.exit(0)
    elif 'error' in response and response['error'] is not None:
        print (response)
        print ("Test failed.")
        sys.exit(-1)

# Method simulating the IA. It creates a RabbitMQ connection and waits for requests with
# 'infrastructure.management.compute.list'
def listen_resource_availability():

    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.exchange_declare(exchange='son-kernel',
                         type='topic')

    result = channel.queue_declare(exclusive=True)
    queue_name = result.method.queue

    channel.queue_bind(exchange='son-kernel',
                       queue=queue_name,
                       routing_key=INFRA_ADAPTOR_AVAILABLE_VIMS)

    channel.basic_consume(available_vims,
                      queue=queue_name,
                      no_ack=True)

    channel.start_consuming()

# Method simulating the IA. It creates a RabbitMQ connection and waits for requests with
# 'infrastructure.service.deploy' topic.
def listen_deploy_ns():

    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.exchange_declare(exchange='son-kernel',
                         type='topic')

    result = channel.queue_declare(exclusive=True)
    queue_name = result.method.queue

    channel.queue_bind(exchange='son-kernel',
                       queue=queue_name,
                       routing_key=INFRA_ADAPTOR_INSTANCE_DEPLOY_REPLY_TOPIC)

    channel.basic_consume(deployment_request_received,
                      queue=queue_name,
                      no_ack=True)

    channel.start_consuming()

# Main method. Creates 3 threads:
# - 1 thread for simulating the GK, which does the deployment request and waits for a response.
# - 1 therad for IA, waiting for requests for compute resoources availabilty
# - 1 thread for IA, waiting for requests for service deployment.

def main():
    t = threading.Thread(target=listen_resource_availability)
    t.daemon = True
    t.start()

    t2 = threading.Thread(target=listen_deploy_ns)
    t2.daemon = True
    t2.start()

    t_gk = threading.Thread(target=send_gk_request)
    t_gk.daemon = True
    t_gk.start()
    t_gk.join()


# Callback method called when a message with 'infrastructure.management.compute.list' topic is sent.
# It reads from file the list of available vims (which are meaningless, it's only for testing) and
# returns them through RabbitMQ with the same topic. This response should be read by SLM.
def available_vims(ch, method, properties, body):
    message = body.decode("utf-8")
    if message == '{}':
        vim_file   = open('resources/vims.yml','r')
        dict = yaml.load(vim_file)
        ch.basic_publish(exchange='son-kernel', routing_key=INFRA_ADAPTOR_AVAILABLE_VIMS, body=yaml.dump(dict), properties=pika.BasicProperties(correlation_id=properties.correlation_id))


# Callback method called when a message with 'infrastructure.service.deploy' topic is sent.
# It reads the nsr and vnfrs whoch the IA should build after deploying the service, and send them
# through the RabbitMQ connection with the same topic. This response should be read by SLM.
def deployment_request_received(ch, method, properties, body):

    msg = yaml.load(body)
    if 'request_status' not in msg:
        ia_nsr   = yaml.load(open('resources/test_records/ia-nsr.yml','r'))
        #print ("Sending message: " + yaml.dump(ia_nsr))
        ch.basic_publish(exchange='son-kernel', routing_key=INFRA_ADAPTOR_AVAILABLE_VIMS, body=yaml.dump(ia_nsr), properties=pika.BasicProperties(correlation_id=properties.correlation_id))

if __name__ == '__main__':
    main()
