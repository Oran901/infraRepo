resource "helm_release" "argocd" {
  name             = "${var.project}-argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.11"
  namespace        = "argocd"
  create_namespace = true


  values = [
    yamlencode({
      global = {
        domain = "argocd.${var.domain_name}" # Replace with your domain
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }

      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
        }
      }
    })
  ]

  depends_on = [helm_release.ingress-nginx]
}





