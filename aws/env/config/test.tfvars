aws_access_key = ""
aws_secret_key = ""
region         = "eu-west-1"
azs            = ["eu-west-1a", "eu-west-1b"]

application = "loopdex"
environment = "test"
prefix      = "loopdex-test"
user_name   = "data-miner-developer-test"

vpc_cidr        = "10.123.0.0/16"
public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]
