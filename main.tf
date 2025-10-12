terraform {
  required_version = ">= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }

  backend "s3" {
    bucket = "353818015911-remotestate"
    key    = "prj-ec2-faat/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${var.key_name}.pem"
  file_permission = "0400"
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    Name = "Terraform EC2"
  }
}
