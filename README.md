
# HW-NGINX 

Homework

Objective:
 - deploy 4 virtualizations with terraform in yandex cloud
 - 1 virtualization - Nginx - with public IP address
 - 2 virtualizers - backend of student's choice (any application from github - uwsgi/unicorn/php-fpm/java) + nginx with statics
 - 1 virtualization with database of student's choice mysql/mongodb/postgres/redis.


The solution for the backend is taken from here

https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/


repository in github: README, schema, terraform and ensemble manifests
the stand should be deployed with terraform and ansible
the system should continue to work when the backend virtualization fails (shuts down).






## Pre-requirements

To run this project, you will need to prepare your yandex cloud, 


and then set environment variables:
```
export TF_VAR_yc_token=$(yc iam create-token)
export TF_VAR_yc_cloud_id=$(yc config get cloud-id)
export TF_VAR_yc_folder_id=$(yc config get folder-id)
```
in this case the terraform.tfvars file is not needed


Also be sure that there is a private/public key mapping at the path ~/.ssh/id_rsa,
else do it via 
```
ssh-keygen
```



## Deployment

To deploy this project run

```bash
  git clone https://github.com/abelovn/hw-nginx.git && cd  hw-nginx/terraform/ && terraform init && terraform plan && terraform apply  -auto-approve && cd ../ansible && ansible-playbook setup.yaml
```
after terraform deploy

go to the ansible directory and run the playbook: ansible-playbook setup.yaml

```
  ansible-playbook setup.yaml
```



PS

If there is no module for Ansible installed, install it


For example
```
 ansible-galaxy collection install community.mysql
```



Nginx (with Wordpress) will be available at ip address from nginx_public_ip_address.

![](https://github.com/abelovn/hw-nginx/blob/main/scheme.png)
