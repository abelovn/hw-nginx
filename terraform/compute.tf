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
