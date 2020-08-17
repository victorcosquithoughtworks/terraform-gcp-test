terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  version = "3.5.0"

  credentials = file("~/terraform-gcp-key.json")

  project = "peak-academy-286409"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  metadata_startup_script = file("http.sh")

  tags = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_firewall" "terraform-network-allow-http" {
  name    = "terraform-network-allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}
resource "google_compute_firewall" "terraform-network-allow-https" {
  name    = "terraform-network-allow-https"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}
resource "google_compute_firewall" "terraform-network-allow-icmp" {
  name    = "terraform-network-allow-icmp"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
}
resource "google_compute_firewall" "terraform-network-allow-ssh" {
  name    = "terraform-network-allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}