output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}