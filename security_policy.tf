# Cloud Armor Security policies
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_security_policy
resource "google_compute_security_policy" "security-policy-1" {
  name        = "armor-security-policy-${var.instance_id}"
  description = "example security policy"

# Reject all traffic that hasn't been whitelisted.
rule {
  action   = "deny(403)"
  priority = "2147483647"
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["*"]
      }
#    description = "Default rule, higher priority overrides it"
    }
}

# Whitelist traffic from certain ip address
  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.ip_white_list
      }
    }
#  description = "allow traffic"
  }
}