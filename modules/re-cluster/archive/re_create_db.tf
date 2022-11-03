


# #Run ansible-playbook to create db
# resource "null_resource" "ansible_create_db" {
#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook ${path.module}/redislabs-create-databases.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/${var.vpc_name}_inventory.ini -e @${path.module}/extra_vars/${var.vpc_name}_inventory.yaml -e @${path.module}/databases/databases.yaml" 
#     }
#     depends_on = [local_file.dynamic_inventory_ini, 
#                   time_sleep.wait_30_seconds,
#                   time_sleep.wait_60_seconds_license_file, 
#                   local_file.extra_vars,
#                   local_file.license_file,
#                   null_resource.ansible-update-re-license]
# }

#ansible-playbook -i $inventory_file redislabs-create-databases.yaml --private-key "~/desktop/keys/bamos-west2-ssh-aws.pem" -e @$extra_vars -e @$databases_file
