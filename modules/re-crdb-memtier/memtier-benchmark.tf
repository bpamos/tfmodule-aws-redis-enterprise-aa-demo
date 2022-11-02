#### Generate ansible inventory file & extra_vars file, run ansible playbook to create cluster

#### Sleeper, just to make sure nodes module is complete and everything is installed
resource "time_sleep" "wait_10_seconds" {
  create_duration = "10s"
}

##### Generate extra_vars.yaml file
resource "local_file" "memtier-benchmark" {
    content  = templatefile("${path.module}/memtier_playbook.yaml.tpl", {
      memtier_data_load_cluster = var.memtier_data_load_cluster
      memtier_benchmark_cmd     = var.memtier_benchmark_cmd
      crdb_endpoint_cluster     = var.crdb_endpoint_cluster
      crdb_port                 = var.crdb_port
    })
    filename = "${path.module}/${var.vpc_name}_memtier_playbook.yaml"
}

######################
# Run ansible-playbook to create cluster
resource "null_resource" "ansible-run" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/${var.vpc_name}_memtier_playbook.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini"
    }

    depends_on = [
      time_sleep.wait_10_seconds,
      local_file.memtier-benchmark
    ]
}
