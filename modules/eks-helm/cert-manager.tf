# resource "helm_release" "cert_manager" {
#   name = "cert-manager"

#   repository       = "https://charts.jetstack.io"
#   chart            = "cert-manager"
#   namespace        = "cert-manager"
#   create_namespace = true
#   version          = "v1.16.2"

#   set {
#     name  = "crds.enabled"
#     value = "true"
#   }

#   # Optional: Used for the DNS-01 challenge.
#   set {
#     name  = "serviceAccount.name"
#     value = "cert-manager"
#   }

#   # Optional: Used for the DNS-01 challenge.
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.dns_manager.arn
#   }
  
#   depends_on = [ helm_release.aws_lbc ]
# }

