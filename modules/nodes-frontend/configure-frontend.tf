#### Sleeperm local file inventories & cfg created
#### otherwise it can run to fast, not find the inventory file and fail or hang
resource "time_sleep" "wait_30_seconds_test" {
  create_duration = "30s"
  depends_on = [local_file.ansible_inventory, 
                local_file.ansible_config]
}


#### Generate Ansible Inventory for each node
resource "local_file" "ansible_inventory" {
    count    = var.test-node-count
    content  = templatefile("${path.module}/ansible/inventories/inventory_test.tpl", {
        host_ip  = element(var.aws_eips, count.index)
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_test_node_${count.index}.ini"
}

# Generate Ansible Configuration
resource "local_file" "ansible_config" {
    content = templatefile("${path.module}/ansible/config/ssh.tpl", {
    vpc_name = var.vpc_name
  })
  filename = "/tmp/${var.vpc_name}_ansible.cfg"
}

#### Generate ansible.cfg file
resource "local_file" "ssh-setup" {
    content  = templatefile("${path.module}/ansible/config/ssh.tpl", {
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_test_node.cfg"
}


#### Generate Ansible Playbook
resource "local_file" "app_py_setup" {
    count    = var.test-node-count
    content  = templatefile("${path.module}/ansible/flaskapp/app.py.tpl", {
        mvn_command  = var.mvn_command
    })
    filename = "${path.module}/ansible/flaskapp/app.py"
}


# Run Ansible playbook to configure front end
resource "null_resource" "ansible_run" {
    count = var.test-node-count
    provisioner "local-exec" {
        command = "ansible-playbook ${path.module}/ansible/playbooks/playbook-deploy-frontend.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini"
  }

  depends_on = [
    local_file.ansible_inventory,
    local_file.ansible_config,
    local_file.ssh-setup
  ]
}
