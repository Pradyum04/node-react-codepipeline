variable "cluster_name" {}
variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "ecr_repo_url" {}
variable "ecs_task_execution_role_arn" {}
variable "ecs_task_role_arn" {}
variable "alb_security_group_id" {}
variable "ecs_security_group_id" {}
variable "acm_certificate_arn" {}
variable "aws_region" {}
variable "environment" { default = "prod" }