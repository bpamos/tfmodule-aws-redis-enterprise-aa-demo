



##### Generate ansible inventory.ini for any number of nodes
resource "local_file" "crdb_tpl" {
    content  = templatefile("${path.module}/crdbs/crdb.tpl", {
        # cluster info
        cluster1     = var.dns_fqdn1
        cluster2     = var.dns_fqdn2
        username1    = var.re_cluster_username
        pwd1         = var.re_cluster_password
        username2    = var.re_cluster_username
        pwd2         = var.re_cluster_password

        # db info
        db_name      = var.crdb_db_name
        port         = var.crdb_port
        memory_size  = var.crdb_memory_size
        replication  = var.crdb_replication
        aof_policy   = var.crdb_aof_policy
        sharding     = var.crdb_sharding
        shards_count = var.crdb_shards_count
    })
    filename = "${path.module}/crdbs/crdb.py"
}


#Run ansible-playbook to create crdb
resource "null_resource" "ansible_create_crdb_restapi" {
  provisioner "local-exec" {
    command = "python3 ${path.module}/crdbs/crdb.py"
    }

    depends_on = [
      local_file.crdb_tpl
    ]
}