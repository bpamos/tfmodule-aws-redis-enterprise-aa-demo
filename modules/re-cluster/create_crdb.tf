


# locals {
#   license_file = (var.license_file == "" ? var.license_file : <<EOF
#     EOF
#     )
# }



##### Generate extra_vars.yaml file
resource "local_file" "license_file" {
    content  = templatefile("${path.module}/licenses/license.tpl", {
      license_file        = var.license_file
    })
    filename = "${path.module}/licenses/license"
}



######################
# Run ansible-playbook to create cluster
resource "null_resource" "ansible-run1" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook ${path.module}/redislabs-update-license.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/${var.vpc_name}_inventory.ini -e @${path.module}/extra_vars/${var.vpc_name}_inventory.yaml -e @${path.module}/group_vars/all/main.yaml" 
    }
    depends_on = [local_file.dynamic_inventory_ini, 
                  time_sleep.wait_30_seconds, 
                  local_file.extra_vars,
                  local_file.license_file]
}


#ansible-playbook -i $inventory_file redislabs-update-license.yaml -e @$extra_vars -e @$group_vars


######################
# # Run ansible-playbook to create cluster
# resource "null_resource" "ansible-run4" {
#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook ${path.module}/redislabs-create-crdbs.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/${var.vpc_name}_inventory.ini -e @${path.module}/extra_vars/${var.vpc_name}_inventory.yaml -e @${path.module}/group_vars/all/main.yaml -e @${path.module}/crdbs/crdbs.yaml" 
#     }
#     depends_on = [local_file.dynamic_inventory_ini, 
#                   time_sleep.wait_30_seconds, 
#                   local_file.extra_vars,
#                   local_file.license_file]
# }


# . source.sh
# ansible-playbook -i $inventory_file redislabs-create-crdbs.yaml -e @$extra_vars -e @$crdbs_file




######################
# # Run ansible-playbook to create cluster
# resource "null_resource" "ansible-run5" {
#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook ${path.module}/redislabs-create-databases.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/${var.vpc_name}_inventory.ini -e @${path.module}/extra_vars/${var.vpc_name}_inventory.yaml -e @${path.module}/group_vars/all/main.yaml -e @${path.module}/databases/databases.yaml" 
#     }
#     depends_on = [local_file.dynamic_inventory_ini, 
#                   time_sleep.wait_30_seconds, 
#                   local_file.extra_vars,
#                   local_file.license_file]
# }



#ansible-playbook -i $inventory_file redislabs-create-databases.yaml -e @$extra_vars -e @$databases_file
