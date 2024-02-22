


# ####################################
# ########### Node Redis Enterprise Module
# #### Create the nodes that will be used for Redis Enterprise
# #### Just create the nodes and associated infra.
# #### configure them and install RE in the config module.
# module "nodes-re1" {
#     source             = "./modules/nodes"
#     providers = {
#       aws = aws.a
#     }
#     owner              = var.owner
#     region             = var.region1
#     vpc_cidr           = var.vpc_cidr1
#     subnet_azs         = var.subnet_azs1
#     ssh_key_name       = var.ssh_key_name1
#     ssh_key_path       = var.ssh_key_path1
#     node-count         = var.data-node-count
#     ec2_instance_type  = var.re_instance_type
#     node-prefix        = var.node-prefix-re
#     ebs-volume-size    = var.re-volume-size
#     create_ebs_volumes = var.create_ebs_volumes_re
#     ### vars pulled from previous modules
#     security_group_id  = module.security-group1.aws_security_group_id
#     ## from vpc module outputs 
#     vpc_name           = module.vpc1.vpc-name
#     vpc_subnets_ids    = module.vpc1.subnet-ids
#     vpc_id             = module.vpc1.vpc-id

#     depends_on = [
#       module.vpc1,
#       module.security-group1
#     ]
# }

# #### Node Outputs to use in future modules
# output "re-data-node-eips1" {
#   value = module.nodes-re1.node-eips
# }

# output "re-data-node-internal-ips1" {
#   value = module.nodes-re1.node-internal-ips
# }

# output "re-data-node-eip-public-dns1" {
#   value = module.nodes-re1.node-eip-public-dns
# }

# #####################################

# #### Configure Redis Enterprise nodes
# #### Ansible playbooks configure and install RE software on nodes
# module "nodes-config-re-1" {
#     source             = "./modules/nodes-config-re"
#     providers = {
#       aws = aws.a
#     }
#     ssh_key_name       = var.ssh_key_name1
#     ssh_key_path       = var.ssh_key_path1
#     re_download_url    = var.re_download_url
#     data-node-count    = var.data-node-count
#     ### vars pulled from previous modules
#     ## from vpc module outputs 
#     vpc_name           = module.vpc1.vpc-name
#     vpc_id             = module.vpc1.vpc-id
#     aws_eips           = module.nodes-re1.node-eips

#     depends_on = [
#       module.nodes-re1
#     ]
# }

# ############## RE Cluster
# #### Ansible Playbook runs locally to create the cluster A
# module "create-cluster1" {
#   source               = "./modules/re-cluster"
#   providers = {
#       aws = aws.a
#     }
#   ssh_key_path         = var.ssh_key_path1
#   region               = var.region1
#   re_cluster_username  = var.re_cluster_username
#   re_cluster_password  = var.re_cluster_password
#   flash_enabled        = var.flash_enabled
#   rack_awareness       = var.rack_awareness
#   ### vars pulled from previous modules
#   vpc_name             = module.vpc1.vpc-name
#   re-node-internal-ips = module.nodes-re1.node-internal-ips
#   re-node-eip-ips      = module.nodes-re1.node-eips
#   re-data-node-eip-public-dns   = module.nodes-re1.node-eip-public-dns
#   dns_fqdn             = module.dns1.dns-ns-record-name
  
#   depends_on           = [
#     module.vpc1, 
#     module.nodes-re1, 
#     module.nodes-config-re-1, 
#     module.dns1]
# }

# #### Cluster Outputs
# output "re-cluster-url" {
#   value = module.create-cluster1.re-cluster-url
# }

# output "re-cluster-username" {
#   value = module.create-cluster1.re-cluster-username
# }

# output "re-cluster-password" {
#   value = module.create-cluster1.re-cluster-password
# }

# ############## RE Cluster CRDB databases
# #### Ansible Playbook runs locally to create the CRDB db between cluster A and B
# module "create-crdbs" {
#   source               = "./modules/re-crdb"
#   providers = {
#       aws = aws.a
#     }
#   re_cluster_username  = var.re_cluster_username
#   re_cluster_password  = var.re_cluster_password
#   dns_fqdn1            = module.dns1.dns-ns-record-name
#   dns_fqdn2            = module.dns2.dns-ns-record-name #getting cluster2 name from other module
#   #### crdb db inputs
#   crdb_db_name         = var.crdb_db_name
#   crdb_port            = var.crdb_port
#   crdb_db_password     = var.crdb_db_password
#   crdb_memory_size     = var.crdb_memory_size
#   crdb_replication     = var.crdb_replication
#   crdb_aof_policy      = var.crdb_aof_policy
#   crdb_sharding        = var.crdb_sharding
#   crdb_shards_count    = var.crdb_shards_count

#   depends_on           = [module.vpc1,
#                           module.vpc2,
#                           module.nodes-re1,
#                           module.nodes-config-re-1,
#                           module.nodes-re2,
#                           module.nodes-config-re-2, 
#                           module.dns1,
#                           module.dns2, 
#                           module.create-cluster1, 
#                           module.create-cluster2]
# }

# #### CRDB Outputs
# output "crdb_endpoint_cluster1" {
#   value = module.create-crdbs.crdb_endpoint_cluster1
# }

# output "crdb_endpoint_cluster2" {
#   value = module.create-crdbs.crdb_endpoint_cluster2
# }

# output "crdb_cluster1_redis_cli_cmd" {
#   value = module.create-crdbs.crdb_cluster1_redis_cli_cmd
# }

# output "crdb_cluster2_redis_cli_cmd" {
#   value = module.create-crdbs.crdb_cluster2_redis_cli_cmd
# }

