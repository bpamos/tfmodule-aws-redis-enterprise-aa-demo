# # ########## Active Active Db Redis Enterprise Clusters between 2 regions (Cluster 2) #####
# # #### Modules to create the following:
# # #### Brand new VPC in region B
# # #### Route table VPC peering id association for VPC B
# # #### Cluster B, RE nodes and install RE software (ubuntu)
# # #### VPC B, Test node with Redis and Memtier
# # #### Cluster B, DNS (NS and A records for RE nodes)
# # #### Cluster B, Create and Join RE cluster
# # #### Run Memtier benchmark data load and benchmark cmd from tester node in VPC B to Cluster B


# ########### VPC Module
# #### create a brand new VPC, use its outputs in future modules
# #### If you already have an existing VPC, comment out and
# #### enter your VPC params in the future modules
# module "vpc2" {
#     source             = "./modules/vpc"
#     providers = {
#       aws = aws.b
#     }
#     aws_creds          = var.aws_creds
#     owner              = var.owner
#     region             = var.region2
#     base_name          = var.base_name2
#     vpc_cidr           = var.vpc_cidr2
#     subnet_cidr_blocks = var.subnet_cidr_blocks2
#     subnet_azs         = var.subnet_azs2
# }

# ### VPC outputs 
# ### Outputs from VPC outputs.tf, 
# ### must output here to use in future modules)
# output "subnet-ids2" {
#   value = module.vpc2.subnet-ids
# }

# output "vpc-id2" {
#   value = module.vpc2.vpc-id
# }

# output "vpc_name2" {
#   description = "get the VPC Name tag"
#   value = module.vpc2.vpc-name
# }

# output "route-table-id2" {
#   description = "route table id"
#   value = module.vpc2.route-table-id
# }

# ########### Security Group Module
# #### create a security group
# module "security-group2" {
#     source             = "./modules/security-group"
#     providers = {
#       aws = aws.b
#     }
#     owner              = var.owner
#     vpc_cidr           = var.vpc_cidr2
#     allow-public-ssh   = var.allow-public-ssh
#     open-nets          = var.open-nets
#     ### vars pulled from previous modules
#     ## from vpc module outputs 
#     vpc_name           = module.vpc2.vpc-name
#     vpc_id             = module.vpc2.vpc-id

#     depends_on = [
#       module.vpc2
#     ]
# }

# output "aws_security_group_id2" {
#   description = "aws security group"
#   value = module.security-group2.aws_security_group_id
# }

# #### Route table association in reigon B (VPC B) for vpc peering id to VPC CIDR in Region A
# module "vpc-peering-routetable2" {
#     source             = "./modules/vpc-peering-routetable"
#     providers = {
#       aws = aws.b
#     }
#     peer_vpc_id               = module.vpc2.vpc-id
#     main_vpc_route_table_id   = module.vpc2.route-table-id
#     vpc_peering_connection_id = module.vpc-peering-requestor.vpc_peering_connection_id
#     peer_vpc_cidr             = var.vpc_cidr1

#     depends_on = [
#       module.vpc1, 
#       module.vpc2, 
#       module.vpc-peering-requestor,
#       module.vpc-peering-acceptor
#     ]
# }

# ####################################
# ########### Node Redis Enterprise Module
# #### Create the nodes that will be used for Redis Enterprise
# #### Just create the nodes and associated infra.
# #### configure them and install RE in the config module.
# module "nodes-re2" {
#     source             = "./modules/nodes"
#     providers = {
#       aws = aws.b
#     }
#     owner              = var.owner
#     region             = var.region2
#     vpc_cidr           = var.vpc_cidr2
#     subnet_azs         = var.subnet_azs2
#     ssh_key_name       = var.ssh_key_name2
#     ssh_key_path       = var.ssh_key_path2
#     node-count         = var.data-node-count
#     ec2_instance_type  = var.re_instance_type
#     node-prefix        = var.node-prefix-re
#     ebs-volume-size    = var.re-volume-size
#     create_ebs_volumes = var.create_ebs_volumes_re
#     ### vars pulled from previous modules
#     security_group_id  = module.security-group2.aws_security_group_id
#     ## from vpc module outputs 
#     vpc_name           = module.vpc2.vpc-name
#     vpc_subnets_ids    = module.vpc2.subnet-ids
#     vpc_id             = module.vpc2.vpc-id

#     depends_on = [
#       module.vpc2,
#       module.security-group2
#     ]
# }

# #### Node Outputs to use in future modules
# output "re-data-node-eips2" {
#   value = module.nodes-re2.node-eips
# }

# output "re-data-node-internal-ips2" {
#   value = module.nodes-re2.node-internal-ips
# }

# output "re-data-node-eip-public-dns2" {
#   value = module.nodes-re2.node-eip-public-dns
# }


# ####################################
# ########### Node Module
# #### Create Test nodes
# #### Create the test nodes and their associated infra
# #### configure them and install RE in the config module.
# module "nodes-tester2" {
#     source             = "./modules/nodes"
#     providers = {
#       aws = aws.b
#     }
#     owner              = var.owner
#     region             = var.region2
#     vpc_cidr           = var.vpc_cidr2
#     subnet_azs         = var.subnet_azs2
#     ssh_key_name       = var.ssh_key_name2
#     ssh_key_path       = var.ssh_key_path2
#     node-count         = var.test-node-count
#     node-prefix        = var.node-prefix-tester
#     ec2_instance_type  = var.test_instance_type
#     create_ebs_volumes = var.create_ebs_volumes_tester
#     ### vars pulled from previous modules
#     security_group_id  = module.security-group2.aws_security_group_id
#     ## from vpc module outputs 
#     vpc_name           = module.vpc2.vpc-name
#     vpc_subnets_ids    = module.vpc2.subnet-ids
#     vpc_id             = module.vpc2.vpc-id

#     depends_on = [
#       module.vpc2,
#       module.security-group2
#     ]
# }

# #### Node Outputs to use in future modules
# output "test-node-eips2" {
#   value = module.nodes-tester2.node-eips
# }

# output "test-node-internal-ips2" {
#   value = module.nodes-tester2.node-internal-ips
# }

# output "test-node-eip-public-dns2" {
#   value = module.nodes-tester2.node-eip-public-dns
# }




# #### Create RE nodes
# #### Ansible playbooks configure and install RE software on nodes
# module "nodes-config-re-2" {
#     source             = "./modules/nodes-config-re"
#     providers = {
#       aws = aws.b
#     }
#     ssh_key_name       = var.ssh_key_name2
#     ssh_key_path       = var.ssh_key_path2
#     re_download_url    = var.re_download_url
#     data-node-count    = var.data-node-count
#     ### vars pulled from previous modules
#     ## from vpc module outputs 
#     vpc_name           = module.vpc2.vpc-name
#     vpc_id             = module.vpc2.vpc-id
#     aws_eips           = module.nodes-re2.node-eips

#     depends_on = [
#       module.nodes-re2
#     ]
# }


# #### Create Test nodes
# #### Ansible playbooks configure Test node with Redis and Memtier
# module "nodes-config-redisoss-2" {
#     source             = "./modules/nodes-config-redisoss"
#     providers = {
#       aws = aws.b
#     }
#     ssh_key_name       = var.ssh_key_name2
#     ssh_key_path       = var.ssh_key_path2
#     test_instance_type = var.test_instance_type
#     test-node-count    = var.test-node-count
#     ### vars pulled from previous modules
#     ## from vpc module outputs 
#     vpc_name           = module.vpc2.vpc-name
#     vpc_id             = module.vpc2.vpc-id
#     aws_eips           = module.nodes-tester2.node-eips

#     depends_on = [
#       module.nodes-tester2
#     ]
# }

# #### Create Test nodes
# #### Ansible playbooks configure Test node with Redis and Memtier
# module "nodes-config-jedis-2" {
#     source             = "./modules/nodes-config-jedis"
#     providers = {
#       aws = aws.b
#     }
#     ssh_key_name       = var.ssh_key_name2
#     ssh_key_path       = var.ssh_key_path2
#     test-node-count    = var.test-node-count
#     ### vars pulled from previous modules
#     ## from vpc module outputs 
#     vpc_name           = module.vpc2.vpc-name
#     vpc_id             = module.vpc2.vpc-id
#     aws_eips           = module.nodes-tester2.node-eips

#     depends_on = [
#       module.nodes-tester2,
#       module.nodes-config-redisoss-2
#     ]
# }


# ########### DNS Module
# #### Create DNS (NS record, A records for each RE node and its eip)
# #### Currently using existing dns hosted zone
# module "dns2" {
#     source             = "./modules/dns"
#     providers = {
#       aws = aws.b
#     }
#     dns_hosted_zone_id = var.dns_hosted_zone_id
#     data-node-count    = var.data-node-count
#     ### vars pulled from previous modules
#     vpc_name           = module.vpc2.vpc-name
#     re-data-node-eips  = module.nodes-re2.node-eips
# }

# #### dns FQDN output used in future modules
# output "dns-ns-record-name2" {
#   value = module.dns2.dns-ns-record-name
# }

# ############## RE Cluster
# #### Ansible Playbook runs locally to create the cluster B
# module "create-cluster2" {
#   source               = "./modules/re-cluster"
#   providers = {
#       aws = aws.b
#     }
#   ssh_key_path         = var.ssh_key_path2
#   region               = var.region2
#   re_cluster_username  = var.re_cluster_username
#   re_cluster_password  = var.re_cluster_password
#   flash_enabled        = var.flash_enabled
#   rack_awareness       = var.rack_awareness
#   ### vars pulled from previous modules
#   vpc_name             = module.vpc2.vpc-name
#   re-node-internal-ips = module.nodes-re2.node-internal-ips
#   re-node-eip-ips      = module.nodes-re2.node-eips
#   re-data-node-eip-public-dns   = module.nodes-re2.node-eip-public-dns
#   dns_fqdn             = module.dns2.dns-ns-record-name
  
#   depends_on           = [
#     module.vpc2, 
#     module.nodes-re2, 
#     module.nodes-config-re-2, 
#     module.dns2]
# }

# #### Cluster Outputs
# output "re-cluster-url2" {
#   value = module.create-cluster2.re-cluster-url
# }

# output "re-cluster-username2" {
#   value = module.create-cluster2.re-cluster-username
# }

# output "re-cluster-password2" {
#   value = module.create-cluster2.re-cluster-password
# }

# ############## RE Cluster CRDB databases memtier benchmark
# #### Ansible Playbook runs locally to run the memtier benchmark cmds for cluster A
# module "memtier_benchmark2" {
#   source               = "./modules/re-crdb-memtier"
#   providers = {
#       aws = aws.b
#     }
#   test-node-count           = var.test-node-count
#   vpc_name                  = module.vpc2.vpc-name
#   ssh_key_path              = var.ssh_key_path2
#   crdb_port                 = var.crdb_port
#   crdb_endpoint_cluster     = module.create-crdbs.crdb_endpoint_cluster2
#   #### memtier inputs (no need to include db endpoint, its auto added)
#   memtier_data_load_cluster = var.memtier_data_load_cluster2
#   memtier_benchmark_cmd     = var.memtier_benchmark_cluster2
  
#   depends_on           = [module.vpc1,
#                           module.vpc2,
#                           module.nodes-re1,
#                           module.nodes-config-re-1,
#                           module.nodes-config-redisoss-1,
#                           module.nodes-re2,
#                           module.nodes-config-re-2,
#                           module.nodes-config-redisoss-2, 
#                           module.dns1,
#                           module.dns2,
#                           module.create-cluster1, 
#                           module.create-cluster2,
#                           module.create-crdbs]
# }

# ### outputs

# output "crdb_cluster2_memtier-data-load-cmd" {
#   value = module.memtier_benchmark2.memtier-data-load-cmd
# }

# output "crdb_cluster2_memtier-benchmark-cmd" {
#   value = module.memtier_benchmark2.memtier-benchmark-cmd
# }

# output "crdb_cluster2_memtier-ansible-playbook-cmd" {
#   value = module.memtier_benchmark2.memtier-ansible-playbook-cmd
# }