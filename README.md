# Terraform GKE Private Cluster Module

This module handles deploying a private cluster to GKE

## Compatibility

 This module is meant for use with Terraform 1.0.0. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/1-0.html)
 use this link to update your Terraform version

## Usage

Simple usage is as follows:

```hcl
module "gke-private-cluster" {
  source                   = "git@github.com/MitchellHamm/gke-private-cluster-terraform-module.git"
  version                  = "~> 1.0"
  project                  = var.project
  region                   = var.region
  application_name         = var.app_name
  environment              = var.environment
  pod_ip_cidr_range        = var.pod_ip_cidr_range
  service_ip_cidr_range    = var.service_ip_cidr_range
  subnetwork_ip_cidr_range = var.subnetwork_ip_cidr_range
  master_ipv4_cidr_block   = var.master_ipv4_cidr_block
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_name | Defines the name of the application | string | n/a | yes |
| environment | Defines the environment of the application. eg. staging, production. | string | n/a | yes |
| master\_authorized\_networks | List of authorized networks that can connect to the Kubernetes API. | list | `[{cidr_block = "xxx.xxx.xxx.xxx/32"display_name = "CA VPN"}]` | no |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning private IP addresses to the cluster master. | string | n/a | yes |
| pod\_ip\_cidr\_range | IP cidr range for the pod IPs. This NEEDS to conform to the RFC 1918 spec otherwise vpc peering will NOT work. eg. 10.64.0.0/20. | string | n/a | yes |
| project | Defines the GCP project to create the cluster in. | string | n/a | yes |
| region | Defines the GCP region to create the cluster in eg. us-central1. | string | n/a | yes |
| release\_channel | Defines the release channel the cluster will be on. Must be one of: UNSPECIFIED, RAPID, REGULAR, STABLE. | string | `"STABLE"` | no |
| subnetwork\_ip\_cidr\_range | IP cidr range for the subnetwork. This NEEDS to conform to the RFC 1918 spec otherwise vpc peering will NOT work. eg. 10.64.0.0/20. | string | n/a | yes |
| service\_ip\_cidr\_range | IP cidr range for the service IPs. This NEEDS to conform to the RFC 1918 spec otherwise vpc peering will NOT work. eg. 10.64.0.0/20. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Name of the cluster |
| container\_network\_name | Name of the container network |
| container\_network\_id | Id of the container network |
| endpoint | Endpoint for the cluster |
| ca_certificate | Ca cert for the cluster. Can be used later for a Kubernetes apply in a script |



## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#iam-roles).
3. The APIs are [active](#enable-apis) on the project you will launch the cluster in.

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) 1.0.x

### Configure a Service Account

In order to execute this module you must have a Service Account with the
following project roles:

- [roles/compute.clusterAdmin](https://cloud.google.com/compute/docs/access/iam)

### Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com