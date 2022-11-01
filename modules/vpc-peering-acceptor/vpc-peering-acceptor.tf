
# data "aws_caller_identity" "current2" {}

# output "account_id" {
#   value = data.aws_caller_identity.current2.account_id
# }

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = var.vpc_peering_connection_id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}