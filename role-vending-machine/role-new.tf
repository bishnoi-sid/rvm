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
  principal_type = "saml"
  # saml_provider_arn =  "arn:aws:iam::867346621613:saml-provider/test-sid"
  # service_name   = ["eks.amazonaws.com"]
  #########this is used to control the aws managed polices and attachments to the role
  managed_policies = []
  # Specify the least permissions required for this pipeline to run
  inline_policy = data.aws_iam_policy_document.example_security_inf_repo_Production_permissions.json
}

#############################################################
module "ent-ektmp-developer-role" {
  source                   = "../github-workflow-roles"
  github_organization_name = var.default_github_organization_name

  # Specify target account
  providers = {
    aws = aws.lab_account
  }

  # Trusted GitHub repository
  repository_name = "bishnoi-sid"
  role_name       = "ent-ektmp-staging002-developer-role"
  # Trusted branch for write operations
  github_branch  = "main"
  principal_type = "saml"
  # saml_provider_arn =  "arn:aws:iam::867346621613:saml-provider/test-sid"
  # service_name   = ["eks.amazonaws.com"]
  #########this is used to control the aws managed polices and attachments to the role
  managed_policies = []
  # Specify the least permissions required for this pipeline to run
  inline_policy = data.aws_iam_policy_document.ent-ektmp-staging002-developer-role.json
}


#############################################################

module "ent-ektmp-administrator-role" {
  source                   = "../github-workflow-roles"
  github_organization_name = var.default_github_organization_name

  # Specify target account
  providers = {
    aws = aws.lab_account
  }

  # Trusted GitHub repository
  repository_name = "bishnoi-sid"
  role_name       = "ent-ektmp-staging002-administrator-role"
  # Trusted branch for write operations
  github_branch  = "main"
  principal_type = "saml"
  # saml_provider_arn =  "arn:aws:iam::867346621613:saml-provider/test-sid"
  # service_name   = ["eks.amazonaws.com"]
  #########this is used to control the aws managed polices and attachments to the role
  managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  # Specify the least permissions required for this pipeline to run
  # inline_policy = data.aws_iam_policy_document.ent-ektmp-staging002-administrator-role.json
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


data "aws_iam_policy_document" "ent-ektmp-staging002-developer-role" {
  # Can include multiple statements
  statement {
    sid = "1"
    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:GetDashboard",
      "cloudwatch:ListDashboards",
    ]
    resources = ["*"]
  }
  statement {
    sid = "2"
    actions = [
      "dynamodb:ListTables",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]
    resources = ["*"]
  }  
  statement {
    sid = "3"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
    ]
    resources = ["*"]
  }   
}

# data "aws_iam_policy_document" "ent-ektmp-staging002-administrator-role" {
#   # Can include multiple statements
#   statement {
#     sid = "1"
#     actions = [
#       "s3:ListAllMyBuckets",
#       "s3:GetBucketLocation",
#     ]
#     resources = [
#       "arn:aws:s3:::*",
#     ]
#   }
# }








