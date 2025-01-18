module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project}-rds"

  engine            = "mysql"
  engine_version    = "8.4.3"
  instance_class    = "db.t4g.micro"
  allocated_storage = 5

  db_name  = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["MYSQL_DB"]
  username = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["MYSQL_USER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["MYSQL_PASSWORD"]
  port     = "3306"

  manage_master_user_password = false

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [ resource.aws_security_group.eks_to_rds.id ]

  tags = {
    Environment = var.environment
  }

  # DB subnet group
  create_db_subnet_group = true
  skip_final_snapshot = true
  subnet_ids             = module.vpc.database_subnets

  create_db_option_group = false
  create_db_parameter_group = false


  depends_on = [ resource.aws_security_group.eks_to_rds ]
}

resource "aws_security_group" "eks_to_rds" {
  name        = "${var.project}-eks-to-rds-sg"
  description = "Allow EKS nodes to access RDS"
  vpc_id      = module.vpc.vpc_id

  # Ingress rule to allow EKS nodes to connect to RDS on port 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL access from EKS nodes"
    security_groups = [ module.eks.node_security_group_id ] # Replace with your EKS nodes' security group ID
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-eks-to-rds-sg"
    environment = var.environment
  }
}

data "aws_secretsmanager_secret" "db_cred" {
  name = "mysql_cred"
}

data "aws_secretsmanager_secret_version" "example" {
  secret_id = data.aws_secretsmanager_secret.db_cred.id
}

module "secret_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.3.1"

  name          = "db_endpoint"
  secret_string = jsonencode({ "MYSQL_HOST" = split(":", module.db.db_instance_endpoint)[0] })
}