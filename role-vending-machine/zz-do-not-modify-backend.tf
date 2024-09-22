# Variable use is not allowed, must be hard-coded to the account you want to apply to
terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "867346621613-tf-remote-state"
    dynamodb_table = "tf-state-lock"
    key            = "rvm/terraform.tfstate"
    region         = "us-east-1"
  }
}