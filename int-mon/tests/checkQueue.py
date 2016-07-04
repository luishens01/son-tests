#! /usr/bin/python

__author__="panos"
__date__ ="$Jun 29, 2016 6:10:32 PM$"

import pika, json
import os, threading, time, signal, sys


if __name__ == "__main__":

    def fail():
        sys.stdout.write("False")
        sys.stdout.flush()
        os._exit(0)
        
    threading.Timer(120, fail).start()
    credentials = pika.PlainCredentials('guest', 'guest')
    connection = pika.BlockingConnection(pika.ConnectionParameters('sp.int3.sonata-nfv.eu',5672,'/',credentials))
    channel = connection.channel()
    channel.queue_declare(queue='son.monitoring')
    
    def callback(ch, method, properties, body):
        obj = json.loads(body)
        if obj["exported_instance"] == 'INT_TEST_VM' and obj["id"] == '0123456789' and obj["alertname"] == 'mon_rule_vm_cpu_perc_test':
            sys.stdout.write("True")
            sys.stdout.flush()
            os._exit(0)
            
    channel.basic_consume(callback,
                      queue='son.monitoring',
                      no_ack=True)
                      
    channel.start_consuming()

