terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "instance_name" {
  type = string
}

variable "instance_size" {
  description = "The Lightsail instance size. View available option via this CLI command: aws lightsail get-bundles"
  type = string
  default = "nano_3_0"
}

variable "instance_blueprint" {
  description = "The Lightsail blueprint. View available option via this CLI command: aws lightsail get-blueprints"
  type = string
  default = "nodejs"
}

variable "ssh_key_pair" {
  
}

variable "admin_cidrs" {
  type = set(string)
}

variable "aditional_port_info" {
  type = set(object({
        protocol = string
        from_port = number
        to_port = number
        cidrs = set(string)
  }))
  nullable = true
  default = null
}

variable "domain_name" {
  type = string
}

variable "availability_zone" {
  description = "The availability zone for resources."
  type = string
  default = "us-west-2a"
  
}

variable "tags" {
  type = map(string)
}


resource "aws_lightsail_instance" "instance" {
  name              = var.instance_name
  availability_zone = var.availability_zone
  blueprint_id      = var.instance_blueprint
  bundle_id         = var.instance_size
  key_pair_name     = var.ssh_key_pair.name
  ip_address_type   = "ipv4"
  tags = var.tags
}

resource "aws_lightsail_static_ip" "instance" {
  name = "${aws_lightsail_instance.instance.name}_static-ip"
}

resource "aws_lightsail_static_ip_attachment" "instance" {
  static_ip_name = aws_lightsail_static_ip.instance.name
  instance_name  = aws_lightsail_instance.instance.name
}

# resource "aws_lightsail_instance_public_ports" "instance" {
#   instance_name = aws_lightsail_instance.instance.name

#   port_info {
#     protocol  = "tcp"
#     from_port = 22
#     to_port   = 22
#     cidrs = var.admin_cidrs
#   }
#   port_info {
#     protocol  = "icmp"
#     from_port = 0
#     to_port   = 0
#     cidrs = var.admin_cidrs
#   }

#   dynamic "port_info" {
#     for_each = var.aditional_port_info == null ? [] : var.aditional_port_info

#     content {
#       protocol  = port_info.value.protocol
#       from_port = port_info.value.from_port
#       to_port   = port_info.value.to_port
#       cidrs     = port_info.value.cidrs
#     }
#   }
# }


output "static_ip" {
  value = aws_lightsail_static_ip.instance.ip_address
}
output "private_ip_address" {
  value = aws_lightsail_instance.instance.private_ip_address
}
output "instance_name" {
  value = aws_lightsail_instance.instance.name
}
output "username" {
  value = aws_lightsail_instance.instance.username
}
# output "fqdn" {
#   value = "${aws_lightsail_domain_entry.instance.name}.${aws_lightsail_domain_entry.instance.domain_name}"
# }