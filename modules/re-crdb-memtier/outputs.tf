#### Outputs



# output "crdb_cluster1_memtier_data_load" {
#   value = format("%s -s redis-%s.%s -p %s", var.memtier_data_load_cluster1, var.crdb_port,var.dns_fqdn1,var.crdb_port)
# }

# output "crdb_cluster2_memtier_data_load" {
#   value = format("%s -s redis-%s.%s -p %s", var.memtier_data_load_cluster2, var.crdb_port,var.dns_fqdn2,var.crdb_port)
# }





#memtier_benchmark -t 4 -c 1 --pipeline 30 -d 300 --key-maximum=2500000 --command="set __key__  __data__" --command-key-pattern=P -n allkeys -s redis-14017.bamos2-tf-us-east-1-cluster.redisdemo.com -p 14017


#memtier_benchmark -t 15 -c 10 --pipeline=30 -d 300 --test-time 300 --run-count 3 --key-maximum=2500000 --command="get __key__" --command-ratio=50 -s redis-14017.bamos2-tf-us-east-1-cluster.redisdemo.com -p 14017


#memtier_benchmark --ratio=1:1 --test-time=300 -d 500 -t 10 -c 10 --pipeline=10 --key-pattern=S:S -x 1 -s redis-14017.bamos1-tf-us-west-2-cluster.redisdemo.com -p 14017