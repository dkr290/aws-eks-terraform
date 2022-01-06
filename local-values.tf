locals {
 
  environment = var.environment
  vpc_name = "eks_vpc"
  vpc_tags = {
   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name = "myVPC"
  }
  common_tags = {
         
      envirenment = local.environment
  }
}