

######################
# Run ansible-playbook to create cluster
# resource "null_resource" "ansible_create_crdbs1" {
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

# #Run ansible-playbook to create crdb
# resource "null_resource" "ansible_create_crdb_restapi1" {
#   provisioner "local-exec" {
#     command = "python3 ${path.module}/crdbs/crdb.py"
#     }
#     depends_on = [local_file.dynamic_inventory_ini, 
#                   time_sleep.wait_30_seconds,
#                   time_sleep.wait_60_seconds_license_file, 
#                   local_file.extra_vars,
#                   local_file.license_file]
# }