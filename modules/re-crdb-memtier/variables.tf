#### Required Variables

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

variable "vpc_name" {
  description = "The VPC Project Name tag"
}

variable "test-node-count" {
  description = "number of data nodes"
}

variable "crdb_port" {
  description = "The crdb port"
}

variable "crdb_endpoint_cluster" {
  description = "dfa"
}

variable "memtier_data_load_cluster" {
  description = "dfa"
  default = "."
}

variable "memtier_benchmark_cmd" {
  description = "dfa"
  default = "."
}