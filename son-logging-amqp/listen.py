#!/usr/bin/env python
import pika
import sys
import os

# tested with
# export broker_host=127.0.0.1
# export broker_exchange=son-kernel

broker_host = os.environ.get("broker_host")
broker_exchange = os.environ.get("broker_exchange")

connection = pika.BlockingConnection(pika.ConnectionParameters(host=broker_host))
channel = connection.channel()

channel.exchange_declare(exchange=broker_exchange,
                         type='topic')

result = channel.queue_declare(exclusive=True)
queue_name = result.method.queue

# lets listen to all topics: binding_key="#"
channel.queue_bind(exchange=broker_exchange,
                   queue=queue_name,
                   routing_key="#")


def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(callback, queue=queue_name, no_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
