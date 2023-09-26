module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                   = "${var.prefix}-${var.name}-eks"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t2.small"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    cluster-ldx = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t2.small"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "example"
      }
    }
  }

  tags = var.default_tags
}
