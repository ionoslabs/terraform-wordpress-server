# Terraform IONOS simple server setup

terraform {
  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
    }
  }
}

provider "ionoscloud" {
  username = var.ionos_username
  password = var.ionos_password
}

resource "ionoscloud_datacenter" "terraform-wp" {
  location    = "us/ewr"
  name        = "terraform-wp1"
  description = "terraform sandbox bash script"
}

resource "ionoscloud_lan" "terraform-lan-1" {
  datacenter_id = ionoscloud_datacenter.terraform-wp.id
  name          = "terraform-lan-1"
  public        = true
}

resource "ionoscloud_server" "terraform-wp1" {
  name              = "terraform-wp1"
  datacenter_id     = ionoscloud_datacenter.terraform-wp.id
  cores             = 2
  ram               = 4 * 1024
  cpu_family        = "AMD_OPTERON"
  availability_zone = "AUTO"
  image_name        = "ubuntu"
  # path below is the path to the public key already created you want to copy to the server instance, enter your local path
  ssh_key_path = [
    "/home/user/.ssh/keyname.pub",
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.primary_ip
  }

  nic {
    lan             = ionoscloud_lan.terraform-lan-1.id
    dhcp            = true
    firewall_active = false
    name            = "wan"
  } 

# note user data section, base encodes the cloud-ini-wp-install.yaml file and places in cloud-init user_data for first boot run
  volume {
    name      = "terraform-wp1-vol1"
    size      = 50
    disk_type = "HDD"
    user_data = "${filebase64("cloud-init-wp-install.yaml")}"
  }
  
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
