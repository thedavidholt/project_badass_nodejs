variable "cf_api_token" {
  sensitive = true
  type = string
  description = "A Cloudflare API token used for managing DNS."
}

variable "admin_ssh_public_key" {
  type = string
}

terraform {
  cloud {
    organization = "project_badass"
  
    workspaces {
        name = "project_badass_workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

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

resource "aws_lightsail_key_pair" "admin" {
  name       = "project_badass-admin"
  public_key = var.admin_ssh_public_key
}

resource "aws_lightsail_instance" "project_badass" {
  name              = "project_badass"
  availability_zone = "us-west-2a"
  blueprint_id      = "nodejs"
  bundle_id         = "nano_3_0"
  ip_address_type   = "ipv4"
  key_pair_name     = aws_lightsail_key_pair.admin.name
  tags = {
    foo = "bar"
  }
}

provider "cloudflare" {
  api_token = var.cf_api_token
}

data "cloudflare_zone" "boblick_net" {
  name = "boblick.net"
}

resource "cloudflare_record" "nfl" {
  zone_id = data.cloudflare_zone.boblick_net.id
  name    = "nfl"
  content   = aws_lightsail_static_ip.project_badass_static_ip.ip_address
  type    = "A"
  proxied = true
  allow_overwrite = true
}

output "ssh_access" {
  value = "${aws_lightsail_instance.project_badass.username}@${aws_lightsail_static_ip.project_badass_static_ip.ip_address}"
}
