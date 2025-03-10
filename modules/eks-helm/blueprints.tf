resource "aws_eks_addon" "pod_identity" {
  cluster_name  = var.cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.4-eksbuild.1"
}

############# eks blueprint ################

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.20.0"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true

  aws_load_balancer_controller = {
    name = "aws-load-balancer-controller"

    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    namespace  = "kube-system"
    version    = "1.8.1"

    values = [<<-EOT
      clusterName: ${var.cluster_name}
      serviceAccount:
        name: aws-load-balancer-controller
      vpcId: ${var.vpc_id}
    EOT
    ]
  }

  metrics_server = {
    name = "metrics-server"

    repository = "https://kubernetes-sigs.github.io/metrics-server/"
    chart      = "metrics-server"
    namespace  = "kube-system"
    version    = "3.12.1"

    values = [<<EOF
    defaultArgs:
        - --cert-dir=/tmp
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        - --metric-resolution=15s
        - --secure-port=10250
    EOF
    ]
  }

   providers = {
    helm       = helm
  }


  tags = {
    Environment = var.environment
  }
}



########### secrets iam ##############

data "aws_iam_policy_document" "myapp_secrets" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = ["system:serviceaccount:external-secrets:${var.environment}-serviceaccount-externalsecrets"]
    }

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "myapp_secrets" {
  name               = "${var.cluster_name}-myapp-secrets"
  assume_role_policy = data.aws_iam_policy_document.myapp_secrets.json
}

resource "aws_iam_policy" "myapp_secrets" {
  name = "${var.cluster_name}-myapp-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = [
          "arn:aws:secretsmanager:us-east-1:767397954823:secret:mysql_cred-aqnnmC",
          "arn:aws:secretsmanager:us-east-1:767397954823:secret:db_endpoint-h7pcLc"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "myapp_secrets" {
  policy_arn = aws_iam_policy.myapp_secrets.arn
  role       = aws_iam_role.myapp_secrets.name
}

