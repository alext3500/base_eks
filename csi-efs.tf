data "aws_iam_role" "eks_efs_role_name" {
  name = var.eks_efs_role_name
}

resource "helm_release" "efs_csi_driver" {
  name = "aws-efs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-efs-csi-driver" # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  }

  set {
    name  = "sidecars.livenessProbe.image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/livenessprobe"
  }

  set {
    name  = "sidecars.nodeDriverRegistrar.image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/csi-node-driver-registrar"
  }

  set {
    name  = "sidecars.csiProvisioner.image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/csi-provisioner"
  }

  set {
    name  = "useFips"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = data.aws_iam_role.eks_efs_role_name.arn
  }

}