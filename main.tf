variable "cf_api_token" {
  sensitive = true
  type = string
  description = "A Cloudflare API token used for managing DNS."
}

variable "admin_cidrs" {
  type = set(string)
}

variable "admin_ssh_public_key" {
  type = string
}

variable "environment" {
  type = string
  default = "dev"
  validation {
    condition = var.environment == "dev" || var.environment == "test" || var.environment == "prod" 
    error_message = "Invalid environment! Allowed values are dev, test, or prod."
  }
}

variable "project_name" {
   type = string
   default = "project_badass"
}

variable "instance_size" {
  description = "The Lightsail instance size. View available option via this CLI command: aws lightsail get-bundles"
  type = string
  default = "nano_3_0"
}

variable "blueprint" {
  description = "The Lightsail blueprint. View available option via this CLI command: aws lightsail get-blueprints"
  type = string
  default = "nodejs"
}

locals {
  domain_name = "boblick.net"
  tags = {
    "${var.project_name}" = ""
    "env" = "${var.environment}"
  }
}

terraform { 
  cloud { 
    organization = "holick_productions" 

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


resource "aws_lightsail_key_pair" "admin" {
  name       = "${var.project_name}-admin"
  public_key = var.admin_ssh_public_key
}

module "web-instance" {
  source = "./terraform/lightsail_instance"
  count = 1
  providers = {
    aws = aws
  }

  instance_name = "${var.project_name}-${var.environment}-${count.index + 1}"
  instance_blueprint = var.blueprint
  instance_size = var.instance_size
  admin_cidrs = var.admin_cidrs
  domain_name = local.domain_name
  ssh_key_pair = aws_lightsail_key_pair.admin
  tags = merge(local.tags, {
    web = ""
  })
}

resource "aws_lightsail_instance_public_ports" "web-ports" {
  for_each = toset(module.web-instance[*].instance_name)
  instance_name = each.value

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_list_aliases = [ "lightsail-connect" ]
    cidrs = var.admin_cidrs
  }
  # icmp is bugged
  port_info {
    protocol  = "icmp"
    from_port = 0
    to_port   = 0
    cidrs = var.admin_cidrs
  }
  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidrs = setunion(
      var.admin_cidrs,
    )
  }
  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidrs = setunion(
      var.admin_cidrs,
      data.cloudflare_ip_ranges.cf_ips.ipv4_cidr_blocks,
    )
    ipv6_cidrs = data.cloudflare_ip_ranges.cf_ips.ipv6_cidr_blocks
  }
}


provider "cloudflare" {
  api_token = var.cf_api_token
}

data "cloudflare_ip_ranges" "cf_ips" {
}

data "cloudflare_zone" "boblick_net" {
  # filter = {
    name = "boblick.net"
    
  # }
  # might want to filter on account_id = "65cddbf0a77a49ae7c1e77e80f241090"
}

resource "cloudflare_zone_settings_override" "boblick_net_settings" {
  zone_id = data.cloudflare_zone.boblick_net.id
  settings {
    ssl = "full"
  }
}

resource "cloudflare_record" "nfl" {
  zone_id = data.cloudflare_zone.boblick_net.id
  name    = "nfl"
  content   = module.web-instance[0].static_ip
  type    = "A"
  proxied = true
  allow_overwrite = true

  # ttl = 1

}

output "ssh_access" {
  value = "${module.web-instance[0].username}@${module.web-instance[0].static_ip}"
}
