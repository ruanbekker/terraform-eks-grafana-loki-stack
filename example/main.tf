module "stack" {
  source = "../"
  
  environment         = var.environment
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  region              = var.region
  elasticache_enabled = var.elasticache_enabled
}