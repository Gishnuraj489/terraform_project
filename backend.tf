terraform {
  backend "s3" {
    bucket         = "gems-bucket-tfstate-files"
    key            = "gems/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "gems-terraform-lock"
    encrypt        = true
 }
}