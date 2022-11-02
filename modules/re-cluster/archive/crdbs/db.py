import requests
import json


headers = {
    'cache-control': 'no-cache',
    'Content-type': 'application/json',
}

username = "admin@admin.com"
pwd = "admin"

data = '''{ "name": "tr05",
"memory_size": 100000000,
"replication": true,
"eviction_policy": "volatile-lru",
"sharding": false,
"shards_count": 1,
"rack_aware": false,
"type": "redis",
"oss_cluster": false,
"proxy_policy": "single",
"shards_placement": "dense",
"port": 12005,
"data_persistence": "aof",
"aof_policy": "appendfsync-always" }'''

resp = requests.post('https://bamos1-tf-us-west-2-cluster.redisdemo.com:9443/v1/bdbs', headers=headers, data=data, verify=False, auth=(username, pwd))
#print(json.dumps(resp.json(), indent=4, sort_keys=True))