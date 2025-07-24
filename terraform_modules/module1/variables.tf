variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to deploy resources"
}
variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the EC2 instance"
  default     = "ami-0cbbe2c6a1bb2ad63" # Example AMI, replace with a valid one
}
variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
  default     = "t2.micro"
}
variable "key_name" {
  type        = string
  description = "The name of the SSH key pair to use for the EC2 instance"
  default     = "gem2_key"
}
