resource "yandex_compute_instance" "lb" {
  count                     = 1
  name                      = "lb${count.index}"
  platform_id               = "standard-v3"
  zone                      = var.yc_zones[count.index % length(var.yc_zones)]
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
      size     = 8
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.yc_subnet[count.index].id
    nat       = true
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nhostname: lb${count.index}"
  }
}

resource "yandex_compute_instance" "db" {
  count                     = 1
  name                      = "db${count.index}"
  platform_id               = "standard-v3"
  zone                      = var.yc_zones[count.index % length(var.yc_zones)]
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
      size     = 8
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.yc_subnet[count.index].id
    nat       = false
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nhostname: db${count.index}"
  }
}

resource "yandex_compute_instance" "app" {
  count                     = 2
  name                      = "app${count.index}"
  platform_id               = "standard-v3"
  zone                      = var.yc_zones[count.index % length(var.yc_zones)]
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
      size     = 8
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.yc_subnet[count.index].id
    nat       = false
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nhostname: app${count.index}"
  }
}
resource "yandex_vpc_network" "this" {
  name = "otus vpc"
}

resource "yandex_vpc_subnet" "yc_subnet" {
  count          = 3
  name           = "otus-subnet-${count.index}"
  v4_cidr_blocks = var.yc_subnets[count.index]
  zone           = var.yc_zones[count.index]
  network_id     = yandex_vpc_network.this.id
  route_table_id = yandex_vpc_route_table.this.id
}

resource "yandex_vpc_gateway" "this" {
  name = "default-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "this" {
  name       = "main-route-table"
  network_id = yandex_vpc_network.this.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.this.id
  }
}

resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.ini"
  file_permission = 0644
  content = templatefile("./inventory.tftpl",
    {
      lb_nat_ip_address_list = yandex_compute_instance.lb[*].network_interface[0].nat_ip_address
      lb_ip_address_list     = yandex_compute_instance.lb[*].network_interface[0].ip_address
      lb_vm_names            = yandex_compute_instance.lb[*].name
      db_ip_address_list     = yandex_compute_instance.db[*].network_interface[0].ip_address
      db_vm_names            = yandex_compute_instance.db[*].name
      app_ip_address_list    = yandex_compute_instance.app[*].network_interface[0].ip_address
      app_vm_names           = yandex_compute_instance.app[*].name
    }
  )
}

resource "local_file" "ansible_config" {
  filename        = "../ansible/ansible.cfg"
  file_permission = 0644
  content = templatefile("./ansible.cfg.tftpl",
    {
      lb_nat_ip_address = yandex_compute_instance.lb[0].network_interface[0].nat_ip_address
    }
  )
}
