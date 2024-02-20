#### Required Variables

variable "region" {
    description = "AWS region"
}

variable "ssh_key_name" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

variable "owner" {
    description = "owner tag name"
}

#### VPC
variable "vpc_cidr" {
    description = "vpc-cidr"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "vpc_name" {
  description = "The VPC Project Name tag"
}

variable "vpc_subnets_ids" {
  type        = list(any)
  description = "The list of subnets available to the VPC"
}

variable "subnet_azs" {
    type = list(any)
    description = "subnet availability zone"
    default = [""]
}

#### Test Instance Variables

#### instance type to use for test node with redis and memtier installed on it
variable "test-node-count" {
  description = "number of data nodes"
  default     = 1
}

variable "test_instance_type" {
    description = "instance type to use. Default: t3.micro"
    default = "t3.micro"
}


variable "ena-support" {
  description = "choose AMIs that have ENA support enabled"
  default     = true
}


#### Security

variable "security_group_id" {
  description = "security group id"
  default     = ""
}