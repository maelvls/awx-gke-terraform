terraform {
  backend "gcs" {
    bucket = "terraform-state-august-period-234610"
    prefix = "gke-terraform/state"
  }
}
