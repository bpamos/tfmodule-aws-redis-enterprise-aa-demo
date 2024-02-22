

# ############## RE Cluster CRDB databases memtier benchmark
# #### Ansible Playbook runs locally to run the memtier benchmark cmds for cluster A
# module "memtier_benchmark1" {
#   source               = "./modules/re-crdb-memtier"
#   providers = {
#       aws = aws.a
#     }
#   test-node-count           = var.test-node-count
#   vpc_name                  = module.vpc1.vpc-name
#   ssh_key_path              = var.ssh_key_path1
#   crdb_port                 = var.crdb_port
#   crdb_endpoint_cluster     = module.create-crdbs.crdb_endpoint_cluster1
#   #### memtier inputs (no need to include db endpoint, its auto added)
#   memtier_data_load_cluster = var.memtier_data_load_cluster1
#   memtier_benchmark_cmd     = var.memtier_benchmark_cluster1
  
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

# output "crdb_cluster1_memtier-data-load-cmd" {
#   value = module.memtier_benchmark1.memtier-data-load-cmd
# }

# output "crdb_cluster1_memtier-benchmark-cmd" {
#   value = module.memtier_benchmark1.memtier-benchmark-cmd
# }

# output "crdb_cluster1_memtier-ansible-playbook-cmd" {
#   value = module.memtier_benchmark1.memtier-ansible-playbook-cmd
# }