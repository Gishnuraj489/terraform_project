provider "aws" {
  region = var.aws_region
}

module "gems_infra" {
  source = "./terraform_modules/module1"
}