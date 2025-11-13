variable "repository_name" {}
variable "environment" { default = "prod" }
variable "allowed_account_arns" {
  type = list(string)
  default = []
}