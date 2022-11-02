#### Required Variables

# variable "main_region" {
#     description = "AWS main region"
# }

# variable "peer_region" {
#     description = "AWS peer region"
# }

# variable "main_vpc_id" {
#   description = "The ID of the requester side VPC"
#   default = ""
# }

# variable "peer_vpc_id" {
#   description = "The ID of the peer side VPC"
#   default = ""
# }

variable "vpc_peering_connection_id" {
  description = "the vpc peering connection id"
  default = ""
}

