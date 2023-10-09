aws_access_key = ""
aws_secret_key = ""

application = "loopdex"
environment = "dev"
prefix      = "loopdex-dev"
user_name   = "data-miner-developer-dev"
region      = "eu-west-2"

vpc_cidr = "10.123.0.0/16"
azs      = ["eu-west-2a", "eu-west-2b"]

public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]
