#!/bin/bash
printf "\n\n======== Create and Increment KPI counter ========\n\n\n"

# It Creates the counter
resp=$(curl -qSfsw '\n%{http_code}' -H 'Content-Type: application/json' -X PUT -d '{ "metric_type": "counter", "job": "sonata", "instance": "gtkkpi", "name": "example_counter", "docstring": "metric counter test", "base_labels": {"label1": "value1", "label2": "value2"}}' http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis)    
code=$(echo "$resp" | tail -n1)
if [[ $code != 201 ]] ;
	then
    	echo "Error: Response error $code"
    	exit -1
fi
resp=$(curl -H 'Content-Type: application/json' -X GET -G 'http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis?name=example_counter&instance=gtkkpi&job=sonata&base_labels%5Blabel1%5D=value1&base_labels%5Blabel2%5D=value2')
echo $resp
first_value=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]["value"]')

echo "Counter example_counter created/updated with value $first_value"

# It increments the counter (+3)
index=0
while [  $index -lt 3 ]; do
	resp=$(curl -qSfsw '\n%{http_code}' -H 'Content-Type: application/json' -X PUT -d '{ "metric_type": "counter", "job": "sonata", "instance": "gtkkpi", "name": "example_counter", "docstring": "metric counter test", "base_labels": {"label1": "value1", "label2": "value2"}}' http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis)    
    code=$(echo "$resp" | tail -n1)
    if [[ $code != 201 ]] ;
  		then
    		echo "Error: Response error $code"
    		exit -1
	fi
    index=$((index+1))
    echo "KPI counter incremented"
done

# Get the couter value
resp=$(curl -H 'Content-Type: application/json' -X GET -G 'http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis?name=example_counter&instance=gtkkpi&job=sonata&base_labels%5Blabel1%5D=value1&base_labels%5Blabel2%5D=value2')
counter_value=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]["value"]')
echo "Counter example_counter incremented. New value: $counter_value"

if [[ !("$counter_value" == "$((first_value+3))") ]]; then
	echo "Error: Counter did not be incremented"
	exit -1
fi

echo "Success: Counter incremented"