resource "random_id" "IKEv2" {
  byte_length = 4
}

provider "google" {
  project = "${var.gcp_project_id}"
  region  = "${var.gcp_region}"
  credentials = "${var.GCP_SA_IAC_KEY}"
}

provider "template" {}
