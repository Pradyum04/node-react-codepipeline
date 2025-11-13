variable "aws_region" { default = "ap-south-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "ecr_repo_name" { default = "evening-repo" }
variable "ecs_cluster_name" { default = "evening-cluster" }
variable "pipeline_name" { default = "evening-pipeline" }
variable "github_repo" {}
variable "github_branch" { default = "main" }
