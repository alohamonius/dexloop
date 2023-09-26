#!/bin/bash

# AWS CLI Configuration
echo "Configuring AWS CLI..."
env=dev
aws configure set aws_access_key_id $access_token
aws configure set aws_secret_access_key $secret
aws configure set region $region

# AWS Deployment
echo "Deploying AWS resources..."
cd /aws

# Run Terraform to create/update resources
terraform init
terraform apply -var-file=config/${env}.tfvars

# Capture the output variable ws_api_url from Terraform
ws_api_url=$(terraform output ws_api_url)

# Return to the main directory
cd ..

# Docker Build and Push
echo "Building and pushing Docker image..."
cd /miner-service

# Build the Docker image
docker build -t miner-service .

# Set your AWS ECR Public repository URL
aws_ecr_repository_url="public.ecr.aws/your-repo-name/miner-service"

# Tag the Docker image for ECR
docker tag miner-service:latest $aws_ecr_repository_url:latest

# Authenticate with AWS ECR Public
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/your-repo-name

# Push the Docker image to ECR
docker push $aws_ecr_repository_url:latest

# Deploy to EKS
echo "Deploying to EKS..."

# You will need to configure kubeconfig for EKS

# Apply Kubernetes resources (e.g., Deployment, Service, etc.) using kubectl
# kubectl apply -f /k8s/deployment.yaml
# kubectl apply -f /k8s/service.yaml

# Optionally, use kubectl to apply any other Kubernetes configurations or resources.

echo "Deployment completed successfully."
