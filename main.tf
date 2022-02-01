#####################################################################
# GKE Cluster
#####################################################################
resource "google_container_cluster" "private_cluster" {
  provider                 = google-beta
  name                     = "${var.application_name}-${var.environment}"
  # This creates a regional cluster with multiple zones for the master node and higher uptime
  location                 = var.region
  # We can't currently create a cluster without a default pool so this hack removes that pool
  # as soon as the cluster is ready
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.container_network.id
  subnetwork               = google_compute_subnetwork.container_subnetwork.id

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  # With private clusters we'll define a cloud NAT via a Terraform module to attach to this cluster
  default_snat_status {
    disabled = true
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.container_subnetwork.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.container_subnetwork.secondary_ip_range[1].range_name
  }

  # Still use a public endpoint IP with a master authorized networks list
  # We could use a VPN to connect to a private master IP 
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  # List of IPs that are whitelisted to interact with the master
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block = cidr_blocks.value["cidr_block"]
        display_name = cidr_blocks.value["display_name"]
      }
    }
  }

  # GKE release channel: UNSPECIFIED, RAPID, REGULAR, STABLE
  release_channel {
    channel = var.release_channel
  }

  # Enable workload identity for allowing linkning GKE and GCP service accounts 
  # to use GCP apis via Kubernetes 
  workload_identity_config {
    identity_namespace = "${var.project}.svc.id.goog"
  }
}

#####################################################################
# Pod & Service Networks
#####################################################################
resource "google_compute_network" "network" {
  name                    = "${var.application_name}-network-${var.environment}"
  # Don't create the subnetworks automatically so we can define IP ranges
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name                     = "${var.application_name}-subnetwork-${var.environment}"
  region                   = var.region
  network                  = google_compute_network.network.name
  ip_cidr_range            = var.subnetwork_ip_cidr_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name             = "pod"
    ip_cidr_range          = var.pod_ip_cidr_range
  }

  secondary_ip_range {
    range_name             = "services"
    ip_cidr_range          = var.service_ip_cidr_range
  }
}
