terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }    
  backend "s3" {
    bucket = "infra01-blob"
    key    = "cv1app/terraform-backend"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "ecs" {
 source = "./modules/ecs"
 subnet_id =  module.vpc.subnet_main
 vpc_id = module.vpc.vpc_main

}

module "route53" {
 source = "./modules/route53"
 subnet_id =  module.vpc.subnet_main
 vpc_id = module.vpc.vpc_main
 main_alb = module.ecs.main_alb
}

# module "lambda" {
#  source = "./modules/route53"
#  subnet_id =  module.vpc.subnet_main
#  vpc_id = module.vpc.vpc_main
#  main_alb = module.ecs.main_alb
# }

#module "devtools" {
#  source = "./modules/devtools"
#  vpc_id = module.vpc.vpc_main
#  subnet_id = module.vpc.subnet_main
#  security_group_id = module.vpc.sg_main
#}
