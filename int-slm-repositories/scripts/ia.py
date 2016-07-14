import pika
import yaml
import threading

# The topic to which available vims are published
INFRA_ADAPTOR_AVAILABLE_VIMS = 'infrastructure.management.compute.list'
# The topic to which service instance deploy replies of the Infrastructure Adaptor are published
INFRA_ADAPTOR_INSTANCE_DEPLOY_REPLY_TOPIC = "infrastructure.service.deploy"

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
    t2.join()


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
        print ("Sending message: " + yaml.dump(ia_nsr))
        ch.basic_publish(exchange='son-kernel', routing_key=INFRA_ADAPTOR_AVAILABLE_VIMS, body=yaml.dump(ia_nsr), properties=pika.BasicProperties(correlation_id=properties.correlation_id))

if __name__ == '__main__':
    main()
