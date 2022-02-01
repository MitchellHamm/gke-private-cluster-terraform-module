#####################################################################
# Outputs
#####################################################################
output "cluster_name" {
  value = google_container_cluster.private_cluster.name
}

output "network_name" {
  value = google_compute_network.network.name
}

output "network_id" {
  value = google_compute_network.network.id
}

output "endpoint" {
  value = google_container_cluster.private_cluster.endpoint
}

output "ca_certificate" {
  value = google_container_cluster.private_cluster.master_auth.0.cluster_ca_certificate
}