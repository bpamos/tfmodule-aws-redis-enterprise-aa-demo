

output "memtier-data-load-cmd" {
  description = "memtier data load cmd"
  value = format("%s -s %s -p %s", var.memtier_data_load_cluster, var.crdb_endpoint_cluster, var.crdb_port)
}



output "memtier-benchmark-cmd" {
  description = "memtier benchmark cmd"
  value = format("%s -s %s -p %s", var.memtier_benchmark_cmd, var.crdb_endpoint_cluster, var.crdb_port)
}

output "memtier-ansible-playbook-cmd" {
  description = "memtier ansible-playbook cmd"
  value = format("ansible-playbook %s/ansible//%s_memtier_playbook.yaml --private-key %s -i /tmp/%s_test_node_%s.ini",path.module, var.vpc_name, var.ssh_key_path, var.vpc_name, 0)

}