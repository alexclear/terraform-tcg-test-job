#!/bin/bash
terraform init
terraform apply -auto-approve
ansible-galaxy install --force -r ./ansible/roles/requirements.yml
sleep 30
ansible-playbook --inventory-file=~/terraform-inventory -e "tcg_mysql_host=`terraform output | cut -d ' ' -f 3 | tr -d '\r\n'`" -u centos -b ansible/site.yml --diff
