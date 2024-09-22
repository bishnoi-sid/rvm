variable "default_github_organization_name" {
  description = "Name of the default GitHub Organization. If not specified otherwise, the role's trust policy will give permissions to the specified repository in this organization."
  type        = string
  default     = "bishnoi-sid"
}

variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "value of the aws-region"
}

variable "account_Production" {
  type        = string
  default     = "867346621613"
  description = "account"
}