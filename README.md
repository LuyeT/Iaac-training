Instructions:
```
script deployment:
  manually provision an instance with centos8stream image
  copy ./example.com.conf ./www.conf ./01-scripts/{configuration.sh , deployment.sh, mariadb-secure-installation.sh} to your instance
  ssh to your instance, chmod +x the scripts
  run configuration.sh, then deployment.sh
```
```
packer snapshot:
  export={your AWS_ACCESS_KEY_ID}
  export={your AWS_SECRET_ACCESS_KEY}
  cd 02-packer/
  packer build lamp-base-image.json
  create new instance from resulting ami
  copy deployment.sh mariadb-secure-installation.sh to new instance
  run deployment script from instance
```
```
terraform provision:
  cd to 03-terraform
  change the ami field of example.tf to the ami of the snapshot you created
  run terraform apply (after configuring keys to your AWS account)
  follow last 2 steps of packer snapshot instructions
```
```
ansible deployment:
  provision instance with terraform
  change ansible-host in inventory.yml to match the IP of your instance
  run ansible-playbook DeployPlaybook.yml
```

basic php/mysql demo should be available at http://{ip of instance}/Fantasy_Taverns-php/index.php for every one of these approaches

ROADMAP
```
[done]     Rewrite scripts with error handling
[done]     Rewrite deployment script to do secure SQL installation
[done]     Rewrite subscript to do secure SQL installation
distribute mysql to seperate server
[done]     Rewrite 02-packer for AWS
[done]     Rewrite 03-terraform for AWS
[done]     04-Ansible
06-Docker
07-Docker Compose
08-Kubernetes
Implement HashiCorp Vault
Redo everything above while using Vault for secrets
```

