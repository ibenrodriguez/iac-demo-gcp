variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "gcp_region" {
  description = "GCP Region"
  default     = "us-central1"
  type        = string
}
variable "GCP_SA_IAC_KEY" {
  description = "GCP Service Account"
  type        = string
}
variable "gcp_subnet1" {
  default = "10.0.0.0/24"
  type    = string
}
variable "gcp_subnet2" {
  default = "10.0.10.0/24"
  type    = string
}
variable "gcp_subnet3" {
  default = "10.0.20.0/24"
  type    = string
}
variable "gcp_subnet4" {
  default = "10.0.30.0/24"
  type    = string
}
variable "gcp_vms_size" {
  default = "f1-micro"
  type    = string
}
variable "gcp_os_r" {
  default = "rhel-8"
  type    = string
}
variable "instance_id" {
  default = "test-vzxy-01"
  type    = string
}

variable "ip_white_list" {
  description = "A list of ip addresses that can be white listed through security policies"
  default     = ["192.0.2.0/24", "0.0.0.0/0"]
}
