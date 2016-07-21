import pika
import yaml

SERVICE_CREATE_TOPIC = 'service.instances.create'

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


def main():
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

    channel.basic_consume(callback,
                      queue=queue_name,
                      no_ack=True)

    channel.basic_publish(exchange='son-kernel', routing_key=SERVICE_CREATE_TOPIC, body=request, properties=pika.BasicProperties(reply_to=queue_name, correlation_id='12322112231'))

    channel.start_consuming()


def callback(ch, method, properties, body):
    print(" [x] GK - Received %r" % (body))




if __name__ == '__main__':
    main()