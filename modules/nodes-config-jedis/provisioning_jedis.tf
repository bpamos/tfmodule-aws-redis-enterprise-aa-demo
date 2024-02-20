#### Generating Ansible config, inventory, playbook 
#### and configuring test nodes and installing Redis and Memtier

#### Sleeper, after instance, eip assoc, local file inventories & cfg created
#### otherwise it can run to fast, not find the inventory file and fail or hang
resource "time_sleep" "wait_30_seconds_test" {
  create_duration = "30s"
  depends_on = [local_file.inventory_setup_test, 
                local_file.ssh-setup-test]
}

# remote-config waits till the node is accessible
resource "null_resource" "remote_config_test" {
  count = var.test-node-count
  provisioner "remote-exec" {
        inline = ["sudo apt update > /dev/null"]

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file(var.ssh_key_path)
            host = element(var.aws_eips, count.index)
        }
    }

    depends_on = [local_file.inventory_setup_test, 
                local_file.ssh-setup-test,
                time_sleep.wait_30_seconds_test]
}

#### Generate Ansible Inventory for each node
resource "local_file" "inventory_setup_test" {
    count    = var.test-node-count
    content  = templatefile("${path.module}/ansible/inventories/inventory_test.tpl", {
        host_ip  = element(var.aws_eips, count.index)
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_test_node_${count.index}.ini"
}

#### Generate ansible.cfg file
resource "local_file" "ssh-setup-test" {
    content  = templatefile("${path.module}/ansible/config/ssh.tpl", {
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_test_node.cfg"
}


############### INSTALL JAVA PROJECT
######################
# Deploy Java project on existing EC2 instance
resource "null_resource" "deploy_java_project" {
  count = var.test-node-count
  provisioner "file" {
    source      = "${path.module}/ansible/jedis-project/"
    destination = "/tmp/"

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file(var.ssh_key_path)
            host = element(var.aws_eips, count.index)
        }
  }


    depends_on = [local_file.inventory_setup_test, 
                local_file.ssh-setup-test,
                time_sleep.wait_30_seconds_test,
                null_resource.remote_config_test]
}


# ######################
# # Run ansible playbook to install java and maven
# resource "null_resource" "java-mvn-install" {
#   count = var.test-node-count
#   provisioner "local-exec" {
#     command = "ansible-playbook ${path.module}/ansible/playbooks/java_mvn_install.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini"
#   }
#   depends_on = [null_resource.deploy_java_project, time_sleep.wait_30_seconds_test]
# }