###### OUTPUT Requires CRDBs to be made
output "mvn_command" {
  description = "Formatted Maven command with endpoint values."
  value = <<-EOT
    mvn compile exec:java -Dexec.cleanupDaemonThreads=false -Dexec.args="--failover true --host ${var.crdb_endpoint_cluster1} --port ${var.crdb_port} --password ${var.crdb_db_password} --host2 ${var.crdb_endpoint_cluster2} --port2 ${var.crdb_port} --password2 ${var.crdb_db_password}"
  EOT
}