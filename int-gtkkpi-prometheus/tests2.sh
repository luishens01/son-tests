#!/bin/bash
printf "\n\n======== Create, Increment and Decrement KPI gauge ========\n\n\n"

# It Creates the gauge
resp=$(curl -qSfsw '\n%{http_code}' -H 'Content-Type: application/json' -X PUT -d '{ "metric_type": "gauge", "operation": "inc", "job": "sonata", "instance": "gtkkpi", "name": "example_gauge", "docstring": "gauge test", "base_labels": {"label1": "value3", "label2": "value4"}}' http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis)
code=$(echo "$resp" | tail -n1)
if [[ $code != 201 ]] ;
	then
    	echo "Error: Response error $code"
    	exit -1
fi
resp=$(curl -H 'Content-Type: application/json' -X GET -G http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis?name=example_gauge -d base_labels[label1]=value3 -d base_labels[label2]=value4)
first_value=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')
echo "Gauge example_gauge created/updated with value $first_value"

# It increments the gauge (+3)
index=1
while [  $index -lt 3 ]; do
	resp=$(curl -qSfsw '\n%{http_code}' -H 'Content-Type: application/json' -X PUT -d '{ "metric_type": "gauge", "operation": "inc", "job": "sonata", "instance": "gtkkpi", "name": "example_gauge", "docstring": "gauge test", "base_labels": {"label1": "value3", "label2": "value4"}}' http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis)
    code=$(echo "$resp" | tail -n1)
    if [[ $code != 201 ]] ;
  		then
    		echo "Error: Response error $code"
    		exit -1
	fi
	index=$((index+1))
done

# Get the couter value
resp=$(curl -H 'Content-Type: application/json' -X GET -G http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis?name=example_gauge -d base_labels[label1]=value3 -d base_labels[label2]=value4)
counter_value=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')
echo "Counter example_counter incremented. New value: $counter_value"

if [[$counter_value -ne $first_value+3]] ;
	then
		echo "Error: Counter did not be incremented"
		exit -1
fi

# It increments the gauge (-1)
resp=$(curl -qSfsw '\n%{http_code}' -H 'Content-Type: application/json' -X PUT -d '{ "metric_type": "gauge", "operation": "dec", "job": "sonata", "instance": "gtkkpi", "name": "example_gauge", "docstring": "gauge test", "base_labels": {"label1": "value3", "label2": "value4"}}' http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis)
code=$(echo "$resp" | tail -n1)
if [[ $code != 201 ]] ;
	then
    	echo "Error: Response error $code"
    	exit -1
fi

# Get the couter value
resp=$(curl -H 'Content-Type: application/json' -X GET -G http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis?name=example_gauge -d base_labels[label1]=value3 -d base_labels[label2]=value4)
counter_value=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["value"]')
echo "Counter example_counter decremented. New value: $counter_value"

if [[$counter_value -ne $first_value+2]] ;
	then
		echo "Error: Counter did not be decremented"
		exit -1
fi