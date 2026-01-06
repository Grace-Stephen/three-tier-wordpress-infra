module "network" {
  source = "../../modules/network"

  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

module "iam" {
  source = "../../modules/iam"

  environment     = var.environment
  ec2_role_name   = var.ec2_role_name
  ec2_policy_arns = var.ec2_policy_arns
}

module "acm" {
  source = "../../modules/acm"

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
}

module "ec2" {
  source = "../../modules/ec2"

  environment           = var.environment
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.private_app_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  instance_profile_name  = module.iam.instance_profile_name
  instance_type = var.instance_type
  db_host     = module.rds.db_endpoint
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  domain_name = var.domain_name
}

module "rds" {
  source = "../../modules/rds"

  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_db_subnet_ids = module.network.private_db_subnet_ids

  app_security_group_id = module.ec2.app_security_group_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  allocated_storage = var.allocated_storage
}

module "alb" {
  source = "../../modules/alb"

  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  app_instance_ids  = module.ec2.instance_ids
  certificate_arn = module.acm.certificate_arn
}


# module "cloudwatch" {
#   source = "../../modules/cloudwatch"

#   environment               = var.environment
#   instance_ids          = module.ec2.instance_ids
#   alb_arn            = module.alb.alb_arn
#   target_group_arn   = module.alb.target_group_arn
#   db_instance_identifier   = module.rds.db_instance_identifier
# }
