dns_name = "app.coinlabs.com"
region = "ap-northeast-2"
instance_name = "apps_coinlabs_${var.env}"
instance_type = "t3.xlarge"
number_of_instances = 1
name = "app_coinlabs_${var.env}_vpc"
cidr = "10.60.0.0/16"
azs = ["ap-northeast-1a", "ap-northeast-1c"] 
private_subnets = ["10.60.1.0/24", "10.60.2.0/24"]
public_subnets = ["10.60.101.0/24", "10.60.102.0/24"]
rds_subnet_group_name = "app_coinlabs_prod_subnet_group"
env = "prod"
db_username = "admin"
db_password = "a34hrjksdnfsdksdf"
db_name = "coinlabs_app_${var.env}"
docker_image = ""
