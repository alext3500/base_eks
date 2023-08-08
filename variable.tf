variable "vpc_name" {
  type        = string
  default     = "vpc-test"
  description = "VPC Name"
}

variable "eks_cluster_name" {
  type        = string
  default     = "test-cluster"
  description = "EKS cluster name"
}

variable "eks_node_role_name" {
  type        = string
  default     = "role-eks-node"
  description = "EKS node role name"
}

variable "eks_lb_role_name" {
  type        = string
  default     = "role-eks-lb-ctrl"
  description = "EKS cluster role name"
}

variable "eks_username_ro" {
  type        = string
  default     = "eks-ro"
  description = "EKS username read-only"
}

variable "eks_username_rw" {
  type        = string
  default     = "eks-rw"
  description = "EKS username read-write"
}

variable "operations_role_name" {
  type        = string
  default     = "role-eks-ops-cluster"
  description = "EKS username for operations"
}