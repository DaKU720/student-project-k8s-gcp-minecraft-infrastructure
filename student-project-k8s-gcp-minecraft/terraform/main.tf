terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# API GKE ON
resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# VPC
resource "google_compute_network" "gke_vpc" {
  name                    = "gke-minecraft-vpc"
  auto_create_subnetworks = false
}

# SUBNET
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-minecraft-subnet"
  region        = var.region
  network       = google_compute_network.gke_vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# CONTROL PLANE
resource "google_container_cluster" "primary" {
  name     = "minecraft-cluster"
  location = var.zone

  network    = google_compute_network.gke_vpc.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1
  depends_on               = [google_project_service.container]
}

# WORKER NODES, SPOT INSTANCES
resource "google_container_node_pool" "primary_nodes" {
  name       = "minecraft-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["minecraft-node"]
  }
}

# FIREWALL
resource "google_compute_firewall" "allow_minecraft" {
  name    = "allow-minecraft"
  network = google_compute_network.gke_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-node"]
}