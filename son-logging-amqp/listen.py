#!/usr/bin/env python
import pika
import sys
import os

broker_host = os.environ.get("broker_host")
broker_exchange = os.environ.get("broker_exchange")

connection = pika.BlockingConnection(pika.ConnectionParameters(host=broker_host))
channel = connection.channel()

channel.exchange_declare(exchange=broker_exchange)

result = channel.queue_declare(exclusive=True)

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(callback,queue=.#,no_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
