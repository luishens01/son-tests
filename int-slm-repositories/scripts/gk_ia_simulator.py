import pika
import yaml
import threading
import sys
import json

SERVICE_CREATE_TOPIC = 'service.instances.create'


# The topic to which available vims are published
INFRA_ADAPTOR_AVAILABLE_VIMS = 'infrastructure.management.compute.list'
# The topic to which service instance deploy replies of the Infrastructure Adaptor are published
INFRA_ADAPTOR_INSTANCE_DEPLOY_REPLY_TOPIC = "infrastructure.service.deploy"


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


def available_vims(ch, method, properties, body):
    message = body.decode("utf-8")
    if message == '{}':
        vim_file   = open('resources/vims.yml','r')
        dict = yaml.load(vim_file)
        ch.basic_publish(exchange='son-kernel', routing_key=INFRA_ADAPTOR_AVAILABLE_VIMS, body=yaml.dump(dict), properties=pika.BasicProperties(correlation_id=properties.correlation_id))


def deployment_request_received(ch, method, properties, body):

    msg = yaml.load(body)
    if 'request_status' not in msg:
        ia_nsr   = yaml.load(open('resources/test_records/ia-nsr.yml','r'))
        #print ("Sending message: " + yaml.dump(ia_nsr))
        ch.basic_publish(exchange='son-kernel', routing_key=INFRA_ADAPTOR_AVAILABLE_VIMS, body=yaml.dump(ia_nsr), properties=pika.BasicProperties(correlation_id=properties.correlation_id))


def is_json(message):
    try:
        json_object = json.loads(message)
        return True
    except ValueError as e:
        return False



if __name__ == '__main__':
    main()
