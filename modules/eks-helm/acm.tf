module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.domain_name
  zone_id      = var.hostedZoneID

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
    "${var.domain_name}",
  ]

  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
  
  depends_on = [ helm_release.aws_lbc ]
}