provider "google" {
  region = "asia-northeast1"
  zone = "asia-northeast1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "tf2-network"
}
