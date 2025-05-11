resource "helm_release" "kube-promethrus-stack" {
  name             = "${var.project}-monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "72.3.0"
  namespace        = "monitoring"
  create_namespace = true


  values = [
    yamlencode({
      grafana = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          annotations = {
            "kubernetes.io/ingress.class" = "nginx"
          }
          hosts = [ "grafana.${var.domain_name}"] 
        }
      }
    })
  ]

  depends_on = [ helm_release.ingress-nginx ]
}





