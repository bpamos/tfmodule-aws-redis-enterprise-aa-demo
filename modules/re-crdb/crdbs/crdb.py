# https://curlconverter.com/
import requests
import json

# cluster info
cluster1     = "bamos1-tf-us-west-2-cluster.redisdemo.com"
cluster2     = "bamos2-tf-us-east-1-cluster.redisdemo.com"
username1    = "admin@admin.com"
pwd1         = "admin"
username2    = "admin@admin.com"
pwd2         = "admin"

# db info
db_name      = "crdb-test1"
port         = 14017
memory_size  = 5024000000
replication  = True
aof_policy   = "appendfsync-every-sec"
sharding     = True
shards_count = 2

headers = {
    # Already added when you pass json= but not when you pass data=
    # 'Content-Type': 'application/json',
}

json_data = {
    'default_db_config': {
        'name': db_name,
        'bigstore': False,
        'replication': replication,
        'memory_size': memory_size,
        'aof_policy': 'appendfsync-every-sec',
        'snapshot_policy': [],
        'sharding': sharding,
        'shards_count': shards_count,
        'shard_key_regex': [
            {
                'regex': '.*\\{(?<tag>.*)\\}.*',
            },
            {
                'regex': '(?<tag>.*)',
            },
        ],
        'port': port,
    },
    'instances': [
        {
            'cluster': {
                'url': 'https://'+cluster1+':9443',
                'credentials': {
                    'username': username1,
                    'password': pwd1,
                },
                'name': cluster1,
            },
            'compression': 6,
        },
        {
            'cluster': {
                'url': 'https://'+cluster2+':9443',
                'credentials': {
                    'username': username2,
                    'password': pwd2,
                },
                'name': cluster2,
            },
            'compression': 6,
        },
    ],
    'name': 'sample-crdb',
}

response = requests.post('https://'+cluster1+':9443/v1/crdbs', headers=headers, json=json_data, verify=False, auth=(username1, pwd1))

