provider "google" {
  region = "asia-northeast1"
  zone = "asia-northeast1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "tf-network"
}

resource "google_compute_instance" "vm_instance" {
  machine_type = "f1-micro"
  name = "terraform-instance"
  tags = ["web", "dev"]
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }
}
