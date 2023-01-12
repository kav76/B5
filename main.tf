terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "kav-tf-state-bucket"
    region     = "ru-central1-a"
    key        = "b5/terraform.tfstate"
    access_key = "XXXXXXX"
    secret_key = "XXXXXXX"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


provider "yandex" {
  token     = "${var.auth_token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
  zone      = "${var.zone}"
}


resource "yandex_vpc_network" "network" {
  name = "network"
}


resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

module "ya_instance_1" {
  source                = "./modules"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
  token     = "${var.auth_token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
  zone_name = "ru-central1-a"
}

module "ya_instance_2" {
  source                = "./modules"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet2.id
  token     = "${var.auth_token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
  zone_name = "ru-central1-c"
}


# Создаем целевую группу
resource "yandex_lb_target_group" "sf-target-group" {
  name      = "sf-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = "${yandex_vpc_subnet.subnet1.id}"
    #address   = "${yandex_compute_instance.my-instance-1.network_interface.0.ip_address}"
    address   = "${module.ya_instance_1.internal_ip_address_vm}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.subnet2.id}"
    #address   = "${yandex_compute_instance.my-instance-2.network_interface.0.ip_address}"
    address   = "${module.ya_instance_2.internal_ip_address_vm}"
  }
}

# Создаем балансировщик
resource "yandex_lb_network_load_balancer" "sf-load-balanser" {
  name = "sf-network-load-balancer"

  listener {
    name = "sf-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.sf-target-group.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
