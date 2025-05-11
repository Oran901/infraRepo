
resource "helm_release" "ingress-nginx" {
  name             = "${var.project}-ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.2"
  namespace        = "ingress"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        kind = "DaemonSet"
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type"         = "external"
            "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
            "service.beta.kubernetes.io/aws-load-balancer-scheme"       = "internet-facing"
            "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"     = module.acm.acm_certificate_arn
            "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"    = "443,80"
          }
          targetPorts = {
            https = "http"
          }
          enableHttp = "false"
        }
      }
    })
  ] 

  
  depends_on = [module.eks_blueprints_addons]
}

# resource "kubectl_manifest" "nginx_test_ingress" {
#   yaml_body = <<EOT
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: "${var.project}-nginx-ingress"
#   namespace: ingress
#   annotations:
#     alb.ingress.kubernetes.io/ssl-redirect: "443"
#     alb.ingress.kubernetes.io/scheme: "internet-facing"
#     alb.ingress.kubernetes.io/target-type: "ip"
#     alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
#     alb.ingress.kubernetes.io/certificate-arn: "${module.acm.acm_certificate_arn}"
# spec:
#   ingressClassName: alb
#   rules:
#     - http:
#         paths:
#           - path: /*
#             pathType: ImplementationSpecific
#             backend:
#               service:
#                 name: ${var.project}-ingress-nginx-controller
#                 port:
#                   number: 80
# EOT

#   depends_on = [helm_release.ingress-nginx]
# }
