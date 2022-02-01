#####################################################################
# Variables
#####################################################################
variable "application_name" {
  type        = string
  description = "Defines the name of the application."
}

variable "environment" {
  type        = string
  description = "Defines the environment of the application."
}

variable "master_authorized_networks" {
  type        = list
  default     = [{}]
  description = "List of authorized networks that can connect to the Kubernetes API"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning private IP addresses to the cluster master."
}

variable "pod_ip_cidr_range" {
  type        = string
  description = "IP cidr range for the pod IPs. This NEEDS to conform to the RFC 1918 spec otherwise vpc peering will NOT work. eg. 10.64.0.0/20"
}

variable "project" {
  type        = string
  description = "Defines the GCP project to create the cluster in"
}

variable "region" {
  type        = string
  description = "Defines the GCP region to create the cluster in eg. us-central1"
}

variable "release_channel" {
  type        = string
  default     = "STABLE"
  description = "Defines the release channel the cluster will be on. Must be one of: UNSPECIFIED, RAPID, REGULAR, STABLE"
}

variable "subnetwork_ip_cidr_range" {
  type        = string
  description = "IP CIDR range for the subnetwork. This NEEDS to conform to the RFC 1918 spec otherwise vpc peering will NOT work. eg. 10.64.0.0/20"
}

variable "service_ip_cidr_range" {
  type        = string
  description = "IP cidr range for the service IPs. This NEEDS to conform to the RFC 1918 spec otherwise vpc peering will NOT work. eg. 10.64.0.0/20"
}