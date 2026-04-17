packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "region" {
  default = "us-east-1"
}

source "amazon-ebs" "linux" {
  region        = var.region
  instance_type = "t3.large"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["137112412989"] # Amazon Linux owner
    most_recent = true
  }

  ssh_username = "ec2-user"

  ami_name = "linux-golden-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.linux"]

  # Setup / base configuration
  provisioner "shell" {
    script = "packer/linux/scripts/setup.sh"
  }

  # Hardening
  provisioner "shell" {
    script = "packer/linux/scripts/hardening.sh"
  }

  # Install tools
  provisioner "shell" {
    script = "packer/linux/scripts/install-tools.sh"
  }

  # Final cleanup (instead of sysprep)
  provisioner "shell" {
    script = "packer/linux/scripts/cleanup.sh"
  }
}
