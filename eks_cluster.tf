
# EKS cluster creation, change version if needed in vars.tf and also cluster name can be changed
# Relying on some external modules to help with the EKS cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnets

  tags = {
    Environment = var.environment
   
  }

  vpc_id =  module.vpc.vpc_id
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }

  }

 eks_managed_node_groups = {
   "worker-group-1" = {
     min_size     = 1
     max_size     = 3
     desired_size = 1
     instance_type = ["t2.small"]
      vpc_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
   }

    "worker-group-2" = {
     min_size     = 1
     max_size     = 3
     desired_size = 1
     instance_type = ["t2.small"]
      vpc_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
   }

 }

depends_on = [
    module.vpc.name
  ]


}



data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}