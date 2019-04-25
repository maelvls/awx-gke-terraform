resource "google_container_cluster" "k8s-cluster" {
  name                     = "august-period-234610"
  remove_default_node_pool = true
  min_master_version       = "1.12.7-gke.7"
  zone                     = "europe-west1-d"

  master_auth {
    username = ""
    password = ""
  }

  logging_service    = "none"
  monitoring_service = "none"

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
    http_load_balancing {
      disabled = true
    }
  }

  initial_node_count = 1

  # Uncomment this if creating a new cluster
  # node_pool {
  #   name = "default-pool"
  #   node_count = "0"
  # }
}

resource "google_container_node_pool" "worker" {
  name       = "worker"
  zone       = "europe-west1-d"
  cluster    = "${google_container_cluster.k8s-cluster.name}"
  node_count = 1

  management = {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-4"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "cluster_name" {
  value = "${google_container_cluster.k8s-cluster.name}"
}

output "zone" {
  value = "${google_container_cluster.k8s-cluster.zone}"
}
