# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones
data "google_compute_zones" "available" {}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "gcp-network" {
  name                    = "gcp-network-${var.instance_id}"
  auto_create_subnetworks = "false"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
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
}

resource "google_compute_subnetwork" "subnet4" {
  name                     = "subnet4-${var.instance_id}"
  ip_cidr_range            = var.gcp_subnet4
  network                  = google_compute_network.gcp-network.name
  region                   = var.gcp_region
}

# Router and Cloud NAT are required for installing packages from repos (apache, php etc)
resource "google_compute_router" "group1" {
  name    = "gw-group1"
  network = google_compute_network.gcp-network.self_link
  region  = var.gcp_region
}

module "cloud-nat-group1" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "1.4.0"
  router     = google_compute_router.group1.name
  project_id = var.gcp_project_id
  region     = var.gcp_region
  name       = "cloud-nat-group1"
}
