# inventory name contains which invetory to use, can override it here
export INVENTORY_NAME=bamos1-tf-us-west-2-cluster_inventory
export inventory_file=./inventories/${INVENTORY_NAME}.ini
export extra_vars=./extra_vars/${INVENTORY_NAME}.yaml

#
export group_vars=./group_vars/all/main.yaml
export license_file=./licenses/license
#export certs_directory=./certs
export databases_file=./databases/databases.yaml
export crdbs_file=./crdbs/crdbs.yaml