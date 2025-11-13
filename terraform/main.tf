

# Pass IAM roles to ECS and CodePipeline modules
module "ecs" {
  source = "./modules/ecs"
  cluster_name       = var.ecs_cluster_name
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  ecr_repo_url       = module.ecr.repository_url
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}

module "codepipeline" {
  source = "./modules/codepipeline"
  pipeline_name       = var.pipeline_name
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  github_token        = var.github_token
  ecs_cluster_name    = var.ecs_cluster_name
  ecs_service_name    = module.ecs.service_name
  ecr_repo_url        = module.ecr.repository_url
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  codebuild_role_arn    = module.iam.codebuild_role_arn
}