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

# Create a new GitLab Lightsail Instance
resource "aws_lightsail_instance" "project_badass" {
  name              = "project_badass"
  availability_zone = "us-west-2a"
  blueprint_id      = "nodejs"
  bundle_id         = "nano_3_0"
  tags = {
    foo = "bar"
  }
}
