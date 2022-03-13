data "google_compute_zones" "available" {}

resource "google_compute_network" "gcp-network" {
  name                    = "gcp-network-${var.instance_id}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1-${var.instance_id}"
  ip_cidr_range = var.gcp_subnet1
  network       = google_compute_network.gcp-network.name
  region        = var.gcp_region
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2-${var.instance_id}"
  ip_cidr_range = var.gcp_subnet2
  network       = google_compute_network.gcp-network.name
  region        = var.gcp_region
}

resource "google_compute_subnetwork" "subnet3" {
  name                     = "subnet3-${var.instance_id}"
  ip_cidr_range            = var.gcp_subnet3
  network                  = google_compute_network.gcp-network.name
  region                   = var.gcp_region
  private_ip_google_access = "true"
}

resource "google_compute_subnetwork" "subnet4" {
  name                     = "subnet4-${var.instance_id}"
  ip_cidr_range            = var.gcp_subnet4
  network                  = google_compute_network.gcp-network.name
  region                   = var.gcp_region
  private_ip_google_access = "true"
}



