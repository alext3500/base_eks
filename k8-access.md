# 1. Edit permissions associated to an account

Import current aws-auth configuration, otherwise terraform cannot overwrite the content

```
$ terraform import kubernetes_config_map_v1.aws_auth kube-system/aws-auth
```

Update aws-auth with kubernetes

```
$ kubectl -n kube-system  edit configmap aws-auth

apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::640022190933:role/role-eks-node
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::640022190933:user/eks_ro
      username: eks_ro
      groups:
        - system:masters
kind: ConfigMap
metadata:
  creationTimestamp: "2023-08-03T16:17:48Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "17971"
  uid: cf64eb21-b318-433d-a988-28ff487131c5
```

Test configurations using profiles

```
$ aws eks update-kubeconfig --region us-east-1 --name test-cluster
```