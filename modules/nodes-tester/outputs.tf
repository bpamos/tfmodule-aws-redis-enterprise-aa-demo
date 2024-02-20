#### Outputs

####

output "test-node-eips" {
  value = aws_eip.test_node_eip[*].public_ip
}

output "test-node-internal-ips" {
  value = aws_instance.test_node[*].private_ip
}

output "test-node-eip-public-dns" {
  value = aws_eip.test_node_eip[*].public_dns #ec2 public dns after EIP association
}