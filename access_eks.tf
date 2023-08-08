data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name
}

data "aws_iam_role" "operations_role" {
  name = var.operations_role_name
}

data "aws_iam_user" "eks_rw" {
  user_name = var.eks_username_rw
}

locals {
  configmap_roles = [
    {
      rolearn  = "${data.aws_iam_role.eks_node_role.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
    },
    {
      rolearn  = "${data.aws_iam_role.operations_role.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
    }
  ]
  configmap_users = [
    {
      userarn  = "${data.aws_iam_user.eks_rw.arn}"
      username = "${data.aws_iam_user.eks_rw.user_name}"
      groups = [
        "system:masters"
      ]
    }
  ]
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(local.configmap_roles)
    mapUsers = yamlencode(local.configmap_users)
  }
}