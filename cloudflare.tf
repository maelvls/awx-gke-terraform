variable "cloudflare_email" {
}

variable "cloudflare_token" {
}

# Configure the Cloudflare provider
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Create a record
resource "cloudflare_record" "www" {
  domain = "touist.eu"
  name   = "*.k8s"
  value  = "${google_container_cluster.k8s-cluster.endpoint}"
  type   = "A"
  ttl    = 3600
  proxied = false # otherwise I need a paid plan
}
