#!/usr/bin/python

## sudo pip install websocket-client
import websocket
import urllib, urllib2, json, os, sys
import thread
import time
global count


def fail():
    sys.stdout.write("False")
    sys.stdout.flush()
    os._exit(-1)

def on_message(ws, message):
    ws.count +=1 
    if ws.count ==2:
        sys.stdout.write("True")
        sys.stdout.flush()
        os._exit(0)

def on_error(ws, error):
    fail()
    pass

def on_close(ws):
    pass

def on_open(ws):
    pass
    

if __name__ == "__main__":
    global count
    count = 0
    url = 'http://sp.int3.sonata-nfv.eu:8000/api/v1/ws/new'
    data = {"metric":"vm_cpu_perc","filters":["type='vnf'"]}
    resp = None
    try: 
        req = urllib2.Request(url)
        req.add_header('Content-Type','application/json')
        req.add_header('Accept','application/json')
        req.get_method = lambda: 'POST'
        response=urllib2.urlopen(req,json.dumps(data))
        code = response.code
        if code == 200:
            resp = response.read()
            ws_url = json.loads(resp)['ws_url']
        else:
            fail()
    except urllib2.HTTPError, e:
        fail()
        pass
    except urllib2.URLError, e:
        fail()
        pass
    except urllib2, e:
        fail()
        pass

    time.sleep(1)
    websocket.enableTrace(False)
    
    ws = websocket.WebSocketApp(ws_url,
                                on_message = on_message,
                                on_error = on_error,
                                on_close = on_close)
    ws.count = 0
    ws.on_open = on_open
    ws.run_forever()
    
    
