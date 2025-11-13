terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket         = "evening-s3"
    key            = "ecs-fargate/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = var.ecr_repo_name
}

module "ecs" {
  source = "./modules/ecs"
  cluster_name = var.ecs_cluster_name
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.public_subnets
  ecr_repo_url = module.ecr.repository_url
}

module "codepipeline" {
  source = "./modules/codepipeline"
  pipeline_name = var.pipeline_name
  github_repo   = var.github_repo
  github_branch = var.github_branch
  ecr_repo_url  = module.ecr.repository_url
  ecs_service_name = module.ecs.service_name
}



