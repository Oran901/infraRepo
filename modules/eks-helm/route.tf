######### dns manager iam ########## 

# data "aws_iam_policy_document" "dns_manager" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${var.oidc_provider}:sub"
#       values   = ["system:serviceaccount:cert-manager:cert-manager"]
#     }

#     principals {
#       identifiers = [var.oidc_provider_arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "dns_manager" {
#   assume_role_policy = data.aws_iam_policy_document.dns_manager.json
#   name               = "${var.project}-dns-manager"
# }

# resource "aws_iam_policy" "dns_manager" {
#   name = "dns_manager"
#   path = "/"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "route53:GetChange",
#         ]
#         Effect   = "Allow"
#         Resource = "arn:aws:route53:::change/*"
#       },
#       {
#         Action = [
#           "route53:ChangeResourceRecordSets",
#           "route53:ListResourceRecordSets"
#         ]
#         Effect   = "Allow"
#         Resource = "arn:aws:route53:::hostedzone/*"
#       },
#       {
#         Action = [
#           "route53:ListHostedZonesByName"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "dns_manager" {
#   policy_arn = aws_iam_policy.dns_manager.arn
#   role       = aws_iam_role.dns_manager.name
# }

# resource "kubectl_manifest" "dns_01_staging" {
#   yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: dns-01
# spec:
#   acme:
#     email: ${var.email}
#     server: https://acme-staging-v02.api.letsencrypt.org/directory
#     privateKeySecretRef:
#       name: dns-01-production-cluster-issuer
#     solvers:
#       - selector:
#           dnsZones:
#             - ${var.domain_name}
#         dns01:
#           route53:
#             region: ${var.region}
#             hostedZoneID: ${var.hostedZoneID}
# YAML

#   depends_on = [helm_release.cert_manager]
# }