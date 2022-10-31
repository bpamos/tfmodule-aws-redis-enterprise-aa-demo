#### Required Variables
# variable "region" {
#     description = "AWS region"
# }

# variable "ssh_key_path" {
#     description = "name of ssh key to be added to instance"
# }

# variable "vpc_name" {
#   description = "The VPC Project Name tag"
# }

####### Create Cluster Variables
####### Node and DNS outputs used to Create Cluster
#### created during node module and used as outputs (no input required)
variable "dns_fqdn1" {
    description = "."
    default = ""
}

variable "dns_fqdn2" {
    description = "."
    default = ""
}

# variable "re-node-internal-ips" {
#     type = list
#     description = "."
#     default = []
# }

# variable "re-node-eip-ips" {
#     type = list
#     description = "."
#     default = []
# }

# variable "re-data-node-eip-public-dns" {
#     type = list
#     description = "."
#     default = []
# }

############# Create RE Cluster Variables

#### Cluster Inputs
#### RE Cluster Username
variable "re_cluster_username" {
    description = "redis enterprise cluster username"
    default     = "admin@admin.com"
}

#### RE Cluster Password
variable "re_cluster_password" {
    description = "redis enterprise cluster password"
    default     = "admin"
}

#### RE CRDB DB variable inputs
variable "crdb_db_name" {
    description = "redis enterprise cluster password"
    default     = "crdb-test1"
}

variable "crdb_port" {
    description = "redis enterprise cluster password"
    default     = 14017
}

variable "crdb_memory_size" {
    description = "redis enterprise cluster password"
    default     = 5024000000
}

variable "crdb_replication" {
    description = "redis enterprise cluster password"
    default     = "True"
}

variable "crdb_aof_policy" {
    description = "redis enterprise cluster password"
    default     = "appendfsync-every-sec"
}

variable "crdb_sharding" {
    description = "redis enterprise cluster password"
    default     = "True"
}

variable "crdb_shards_count" {
    description = "redis enterprise cluster password"
    default     = 2
}