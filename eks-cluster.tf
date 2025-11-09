module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.28"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    application = {
      name = "application-nodes"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 5
      desired_size = 3

      vpc_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }

    platform = {
      name = "platform-nodes"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 5
      desired_size = 2

      vpc_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
