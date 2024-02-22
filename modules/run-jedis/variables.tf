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

variable "mvn_command" {
  description = "jedis mvn cmd"
  default = "."
}