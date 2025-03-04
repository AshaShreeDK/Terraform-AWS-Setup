module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "ec2" {
  source  = "./modules/ec2"
  ami_id  = var.ami_id
  subnets = module.vpc.private_subnets
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.alb.alb_sg_id 
  instance_ids   = module.ec2.instance_ids
}

module "route53" {
  source            = "./modules/route53"
  vpc_id            = module.vpc.vpc_id
  private_zone_name = var.private_zone_name
  instances         = module.ec2.instances
}
