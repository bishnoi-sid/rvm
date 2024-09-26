module "example_security_inf_repo_Production" {
  source                   = "../github-workflow-roles"
  github_organization_name = var.default_github_organization_name

  # Specify target account
  providers = {
    aws = aws.lab_account
  }

  # Trusted GitHub repository
  repository_name = "bishnoi-sid"
  role_name       = "test-siddhant-rvm"
  # Trusted branch for write operations
  github_branch  = "main"
  principal_type = ""

  #########this is used to control the aws managed polices and attachments to the role
  managed_policies = []
  # Specify the least permissions required for this pipeline to run
  inline_policy = data.aws_iam_policy_document.example_security_inf_repo_Production_permissions.json
}


######### This is used to control the inline polices and attachments to the role
data "aws_iam_policy_document" "example_security_inf_repo_Production_permissions" {
  # Can include multiple statements
  statement {
    sid = "1"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
}








