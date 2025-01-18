resource "helm_release" "external-secrets" {
  name = "external-secrets-operator"

  repository = "https://charts.external-secrets.io"
  chart = "external-secrets"
  namespace = "external-secrets"
  create_namespace = true
  version = "0.12.1"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.myapp_secrets.arn
  }

  set {
    name  = "installCRDS"
    value = "true"
  }

  set {
    name = "serviceAccount.name"
    value = "${var.environment}-serviceaccount-externalsecrets"
  }

  
}

resource "kubectl_manifest" "clustersecretstore_sample" {
  yaml_body = <<EOT
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: ${var.environment}-secretstore
spec:
  provider:
    aws:
      service: SecretsManager
      region: ${var.region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${var.environment}-serviceaccount-externalsecrets
            namespace: external-secrets
EOT

  depends_on = [helm_release.external-secrets]
}
