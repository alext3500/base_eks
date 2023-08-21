# 1. Edit permissions associated to an account

Import current aws-auth configuration, otherwise terraform cannot overwrite the content

```
$ terraform import kubernetes_config_map_v1.aws_auth kube-system/aws-auth
```

Update aws-auth with kubernetes

```
$ aws sts get-caller-identity --profile eks_rw
$ kubectl -n kube-system  describe configmap aws-auth
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

$ aws sts get-caller-identity
$ aws sts assume-role --duration-seconds 28800 --role-arn "arn:aws:iam::ACCOUNT-ID:role/my-iam-role" --role-session-name my-role-session




$ aws ecr get-login-password --region us-east-1 --profile admin | docker login --username AWS --password-stdin 602401143452.dkr.ecr.us-east-1.amazonaws.com

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=test-cluster \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller



