terraform {
  cloud {
    # The name of your Terraform Cloud organization.
    organization = "project_badass"
  
    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
        name = "project_badass_workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_static_ip_attachment" "project_badass_static_ip_atachment" {
  static_ip_name = aws_lightsail_static_ip.project_badass_static_ip.id
  instance_name  = aws_lightsail_instance.project_badass.id
}

resource "aws_lightsail_static_ip" "project_badass_static_ip" {
  name = "project_badass_static_ip"
}

resource "aws_lightsail_instance" "project_badass" {
  name              = "project_badass"
  availability_zone = "us-west-2a"
  blueprint_id      = "nodejs"
  bundle_id         = "nano_3_0"
  ip_address_type = "ipv4"
  tags = {
    foo = "bar"
  }
}

output "project_badass_public_ip" {
  value = aws_lightsail_static_ip.project_badass_static_ip.ip_address
}