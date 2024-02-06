# tfmodule-aws-redis-enterprise-aa-demo
Deploy an Active-Active CRDB database between two Redis Enterprise Clusters in different regions.

Then run memtier benchmark load test from tester nodes into each cluster.
* (*there will be outputs of 2 ansible playbook cmds to run the data load and benchmark memtier cmd straight from the terminal, no need to ssh into each tester node and run there*)


* Example of deployment: (user can choose any number of RE nodes and any number of tester nodes to deploy)
![Alt text](image/TF-AA-DEMO.png?raw=true "Title")

*********

## Quick Start
If you dont think you need to read the detailed instructions, please click here [Instructions-for-use](#instructions-for-use)

## Terraform Modules to provision the following:
* Two new VPCs (VPC in region A & VPC in region B)
* VPC peering between the two VPCs (inter-region VPC peering)
* Route table association for VPC peer ID on both VPCs 
* Any number of Redis Enterprise nodes and install Redis Enterprise software (ubuntu 18.04)
* Test node with Redis and Memtier installed
* DNS (NS and A records for Redis Enterprise nodes)
* Create and Join Redis Enterprise cluster
    * cluster creation options: redis on ram, redis on flash, and or rack zone awareness
* Redis Enterprise License added to cluster (**User input of license file required** [Input Redis Enterprise License File](#instructions-for-use))
* Create CRDB database between Cluster A & Cluster B
    * *note: auto-generated CRDB db will be a Redis on RAM without Rack Awareness by default*
* print output of memtier benchmark commands that will run from Tester nodes in each VPC to associated Cluster
    * (*note: you can run these in the terminal for more instructions* [run memtier commands](#run-memtier-cmds)

### !!!! Requirements !!!
* Redis Enterprise Software (**Ubuntu 18.04**)
* R53 DNS_hosted_zone_id *(if you do not have one already, go get a domain name on Route53)*
* aws access key and secret key
* an **AWS generated** SSH key for **each region** where you are creating a cluster
    - To create new keys: ([link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html))
        - **MUST INCLUDE REGION PARAMETER**
    - Example:
    - Region A SSH key
    ```
    aws ec2 create-key-pair \
    --key-name my-key-pair-west \
    --key-type rsa \
    --key-format pem \
    --query “KeyMaterial” \
    --region “us-west-2" \
    --output text > my-key-pair-west.pem
    ```
    - Region B SSH Key
    ```
    aws ec2 create-key-pair \
    --key-name my-key-pair-east \
    --key-type rsa \
    --key-format pem \
    --query “KeyMaterial” \
    --region “us-east-1" \
    --output text > my-key-pair-east.pem
    ```
    - **you must chmod 400 the key before use**


* Redis Enterprise License File input in the `re-license` folder
    - Free Trial License found here ([link](https://redis.com/redis-enterprise-software/pricing/))
* Redis Enterprise Software Download:
    - ([link](https://redis.com/redis-enterprise-software/download-center/software/))

### Prerequisites
* aws-cli (aws access key and secret key)
* terraform installed on local machine
* ansible installed on local machine
* install `requirements.txt` file
    - `pip3 install -r requirements.txt`

#### Prerequisites (detailed instructions)
1.  Install `aws-cli` on your local machine and run `aws configure` ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)) to set your access and secret key.
    - If using an aws-cli profile other than `default`, `main.tf` may need to edited under the `provider "aws"` block to reflect the correct `aws-cli` profile.
2.  Download the `terraform` binary for your operating system ([link](https://www.terraform.io/downloads.html)), and make sure the binary is in your `PATH` environment variable.
    - MacOSX users:
        - (if you see an error saying something about security settings follow these instructions), ([link](https://github.com/hashicorp/terraform/issues/23033))
        - Just control click the terraform unix executable and click open. 
    - *you can also follow these instructions to install terraform* ([link](https://learn.hashicorp.com/tutorials/terraform/install-cli))
 3.  Install `ansible` via `pip3 install ansible` to your local machine.
     - A terraform local-exec provisioner is used to invoke a local executable and run the ansible playbooks, so ansible must be installed on your local machine and the path needs to be updated.
     - example steps:

    ```
    # create virtual environment
    python3 -m venv ./venv
    source ./venv/bin/activate
    # Check if you have pip
    python3 -m pip -V
    # Install ansible and check if it is in path
    python3 -m pip install --user ansible
    # check if ansible is installed:
    ansible --version
    # If it tells you the path needs to be updated, update it
    echo $PATH
    export PATH=$PATH:/path/to/directory
    # example: export PATH=$PATH:/Users/username/Library/Python/3.8/bin
    # (*make sure you choose the correct python version you are using*)
    # you can check if its in the path of your directory by typing "ansible-playbook" and seeing if the command exists

    # To run crdb python script and ansible please install requirements.txt file
    pip3 install -r requirements.txt
    ```

* (*for more information on how to install ansible to your local machine:*) ([link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))

## Getting Started:
Now that you have terraform and ansible installed you can get started provisioning your RE clusters on AWS using terraform modules.

Since creating a Redis Enterprise cluster from scratch takes many components (VPC, DNS, Nodes, and creating the cluster via REST API) it is best to break these up into invidivual `terraform modules`. That way if a user already has a pre-existing VPC, they can utilize their existing VPC instead of creating a brand new one.

There are a few important files to understand. `modules-cluster1.tf`, `modules-cluster2.tf`  and `terraform.tfvars.example`.
* `modules-cluster1.tf` contains the following: 
    - `vpc module` (creates new VPC1)
    - `vpc-peering-requestor module` (initiates vpc request from vpc1 to vpc2)
    - `vpc-peering-acceptor module` (accepts vpc request from vpc2 to vpc1)
    - `vpc-peering-routetable module` (associates vpc2 CIDR to vpc1 for vpc-peering-id)
    - `node module` (creates and provisions ubuntu 18.04 vms with RE software installed or test vms with Redis and Memtier installed)
    - `dns module` (creates R53 DNS with NS record and A records), 
    - `create-cluster module` (uses ansible to create and join the RE cluster via REST API, and installs RE license file)
    - `re-crdb module` (creates a crdb in cluster 1, with participating cluster, cluster 2)
    - `re-crdb-memtier module` (runs memtier benchmark cmds from tester node in vpc 1 to associated cluster 1)
    * *the individual modules can contains inputs from previously generated from run modules.*

* `modules-cluster2.tf` contains the following: 
    - `vpc module` (creates new VPC2)
    - `vpc-peering-routetable module` (associates vpc1 CIDR to vpc2 for vpc-peering-id)
    - `node module` (creates and provisions ubuntu 18.04 vms with RE software installed or test vms with Redis and Memtier installed)
    - `dns module` (creates R53 DNS with NS record and A records), 
    - `create-cluster module` (uses ansible to create and join the RE cluster via REST API, and installs RE license file)
    - `re-crdb-memtier module` (runs memtier benchmark cmds from tester node in vpc 2 to associated cluster 2)
    * *the individual modules can contains inputs from previously generated from run modules.*


* **example:**
    ```
    # either use the variables filled in from `.tfvars` as seen below
    module "vpc" {
    source             = "./modules/vpc"
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region
    base_name          = var.base_name
    vpc_cidr           = var.vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs         = var.subnet_azs
    }

    # or enter in your own values:
    module "vpc" {
    source             = "./modules/vpc"
    aws_creds          = ["accessxxxx","secretxxxxxx"]
    owner              = "redisuser"
    region             = "us-west-2"
    base_name          = "redis-user-tf"
    vpc_cidr           = "10.0.0.0/16"
    subnet_cidr_blocks = ["10.0.0.0/24","10.0.16.0/24","10.0.32.0/24"]
    subnet_azs         = ["us-west-2a","us-west-2b","us-west-2c"]
    }
    ```
* `terraform.tfvars.example`:
    - An example of a terraform variable managment file. The variables in this file are utilized as inputs into the module file. You can choose to use these or hardcode your own inputs in the modules file.
    - to use this file you need to change it from `terraform.tfvars.example` to simply `terraform.tfvars` then enter in your own inputs.

* `re-license.txt.example`:
    - An example of a Redis Enterprise License file located in the `re-license` folder. You will need to change this to an existing license file.
    - to use this file you need to change it from `re-license.txt.example` to simply `re-license.txt` then enter in your own license file.
     - Free Trial License found here ([link](https://redis.com/redis-enterprise-software/pricing/))

***************

### Instructions for Use:
1. Open repo in VS code
2. Copy the variables template. or rename it `terraform.tfvars`
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```
3. Update `terraform.tfvars` variable inputs with your own inputs
    - Some require user input, some will will use a default value if none is given
4. Input Redis Enterprise License file in the `re-license` folder
    - change the `re-license.txt.example` to simply `re-license.txt` then enter in your license file.
    - Free Trial License found here ([link](https://redis.com/redis-enterprise-software/pricing/))

5. Now you are ready to go!
    * Open a terminal in VS Code:
    ```bash
    # create virtual environment
    python3 -m venv ./venv
    # install requirements.txt file
    pip3 install -r requirements.txt
    # ensure ansible is in path (you should see an output showing ansible is there)
    # if you see nothing refer back to the prerequisites section for installing ansible.
    ansible --version
    # run terraform commands
    terraform init
    terraform plan
    terraform apply
    # Enter a value: yes
    # can take around 10 minutes to provision cluster
    # then will print outputs of cluster FQDN and Ansible cmds
    # for running the memtier data loading & benchmark cmds per cluster
    ```

6. After a successful run there should be outputs showing the FQDNs of your RE clusters and the username and password. It will also have outputs for ansible cmds that you can run in the terminal to run the memtier data load & benchmark cmd per cluster (*you may need to scroll up a little*)
 - example output:
```
outputs:

crdb_cluster1_memtier-ansible-playbook-cmd = "ansible-playbook modules/re-crdb-memtier/ansible//redis1-tf-us-west-2-cluster_memtier_playbook.yaml --private-key ~/desktop/keys/key-west2-ssh-aws.pem -i /tmp/redis1-tf-us-west-2-cluster_test_node_0.ini"
crdb_cluster1_memtier-benchmark-cmd = "memtier_benchmark -x 1 --ratio=1:1 --test-time=300 -d 500 -t 10 -c 10 --pipeline=10 --key-pattern=S:S --key-prefix='1clusterA' -s redis-12001.redis1-tf-us-west-2-cluster.redisdemo.com -p 12001"
crdb_cluster1_memtier-data-load-cmd = "memtier_benchmark -t 4 -c 1 --pipeline 30 -d 300 --key-maximum=2500000 --key-prefix='1clusterA' --key-pattern=P:P -n allkeys -s redis-12001.redis1-tf-us-west-2-cluster.redisdemo.com -p 12001"
crdb_cluster1_redis_cli_cmd = "redis-cli -h redis-12001.redis1-tf-us-west-2-cluster.redisdemo.com -p 12001"
crdb_cluster2_memtier-ansible-playbook-cmd = "ansible-playbook modules/re-crdb-memtier/ansible//redis2-tf-us-east-1-cluster_memtier_playbook.yaml --private-key ~/desktop/keys/key-east1-ssh-aws.pem -i /tmp/redis2-tf-us-east-1-cluster_test_node_0.ini"
crdb_cluster2_memtier-benchmark-cmd = "memtier_benchmark -x 1 --ratio=1:1 --test-time=300 -d 500 -t 10 -c 10 --pipeline=10 --key-pattern=S:S --key-prefix='2clusterB' -s redis-12001.redis2-tf-us-east-1-cluster.redisdemo.com -p 12001"
crdb_cluster2_memtier-data-load-cmd = "memtier_benchmark -t 4 -c 1 --pipeline 30 -d 300 --key-maximum=2500000 --key-prefix='2clusterB' --key-pattern=P:P -n allkeys -s redis-12001.redis2-tf-us-east-1-cluster.redisdemo.com -p 12001"
crdb_cluster2_redis_cli_cmd = "redis-cli -h redis-12001.redis2-tf-us-east-1-cluster.redisdemo.com -p 12001"
crdb_endpoint_cluster1 = "redis-12001.redis1-tf-us-west-2-cluster.redisdemo.com"
crdb_endpoint_cluster2 = "redis-12001.redis2-tf-us-east-1-cluster.redisdemo.com"
dns-ns-record-name1 = "redis1-tf-us-west-2-cluster.redisdemo.com"
dns-ns-record-name2 = "redis2-tf-us-east-1-cluster.redisdemo.com"
re-cluster-password = "admin"
re-cluster-password2 = "admin"
re-cluster-url = "https://redis1-tf-us-west-2-cluster.redisdemo.com:8443"
re-cluster-url2 = "https://redis2-tf-us-east-1-cluster.redisdemo.com:8443"
re-cluster-username = "admin@admin.com"
re-cluster-username2 = "admin@admin.com"
```

#### Accessing the Clusters
* Output name: `re-cluster-url` & `re-cluster-url2`
    * go to chrome browser, enter in the output https address, accept the privacy button, log in via outputs `re-cluster-username` & `re-cluster-password`

#### Run Memtier Cmds
Run an ansible-playbook that contains configured memtier cmds for data loading and benchmark for each cluster. You can run the ansible-playbook from the terminal, so you do not need to access the `test-nodes` themselves. The ansible-playbook will access the `test-node` and run the memtier data load & benchmark.
* Output name: `crdb_cluster1_memtier-ansible-playbook-cmd` & `crdb_cluster2_memtier-ansible-playbook-cmd`
    * copy the output and run it in the terminal for one cluster, you will need to open a second terminal to run the other ansible playbook at the same time.
    * The memtier cmds load data from the test node located in the clusters region into that cluster, then run a benchmark cmd. So if you want to run the data load and benchmark in both clusters at the same time, you will need to open two terminals and run each cmd in one of them.

## Cleanup

Remove the resources that were created.

```bash
  terraform destroy
  # Enter a value: yes
```

## Additional Helpful Repos
Utilized a lot of information from the following repos to create this:

Terraform and Ansible repo for installing RE on ubuntu 18.04 nodes:
* https://github.com/Redislabs-Solution-Architects/tfmodule-aws-redis-enterprise

Ansible Redis PS Repo:
* https://github.com/Redislabs-Solution-Architects/ansible-redis




######
```bash
sudo su -
cd /tmp/jedis-failover-demo

mvn compile exec:java -Dexec.cleanupDaemonThreads=false -Dexec.args="--failover true --host redis-12001.bamos1-tf-us-west-2-cluster.redisdemo.com --port 12001 --password password --host2 redis-12001.bamos2-tf-us-east-1-cluster.redisdemo.com --port2 12001 --password2 password"

```