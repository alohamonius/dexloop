Commands:

1. terraform init (set files in directory, .terrafrom with modules )
2. terraform plan # compare desired and actual states
3. terraform apply (deploy)
4. terraform destory

ENVS:
terraform apply -var-file=
terraform apply -var="ami=123" -var="" -var="" ...

State file (.tfstate):

- Represent world (.json about every resources and object)
- !Passwords displays here
- Usually stores on cloud (s3)

Scanning DynamoDB is not ideal in terms of cost or performance. I've learned this the hard way.
