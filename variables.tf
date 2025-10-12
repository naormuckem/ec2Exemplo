variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI to use for the EC2 instance."
  default     = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 LTS in us-east-1
}

variable "key_name" {
  description = "The name of the SSH key pair."
  default     = "terraform-key"
}
