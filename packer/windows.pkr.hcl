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

source "amazon-ebs" "windows" {
  region        = var.region
  instance_type = "t3.large"

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2019-English-Full-Base-*"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  communicator   = "winrm"
  winrm_username = "Administrator"

  ami_name = "windows-golden-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.windows"]

  provisioner "powershell" {
  scripts = [
    "packer/scripts/setup.ps1"
  ]
}

provisioner "powershell" {
  script = "packer/scripts/sysprep.ps1"
}
}
