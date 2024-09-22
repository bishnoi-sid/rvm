module "example_security_inf_repo_Production" {
  source                   = "../github-workflow-roles"
  github_organization_name = var.default_github_organization_name

  # Specify target account
  providers = {
    aws = aws.lab_account
  }

  # Trusted GitHub repository
  repository_name = "bishnoi-sid"
  role_name = "test-siddhant-rvm"
  # Trusted branch for write operations
  github_branch = "main"
  principal_type  = ""

  # Specify the least permissions required for this pipeline to run
  inline_policy = data.aws_iam_policy_document.example_security_inf_repo_Production_permissions.json
}

data "aws_iam_policy_document" "example_security_inf_repo_Production_permissions" {
  # Can include multiple statements
  statement {
    sid    = "SQSQueues"
    effect = "Allow"
    actions = [
      "sqs:CreateQueue",
      "sqs:DeleteQueue",
      "sqs:TagQueue",
      "sqs:UntagQueue",
      "sqs:SetQueueAttributes"
    ]
    # Reference account numbers using the `variables-accounts` file
    resources = ["arn:aws:sqs:*:${var.account_Production}:aws-s3-access-logs"]
  }
}








