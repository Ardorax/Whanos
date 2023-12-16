variable "region" {
  type        = string
  default     = "europe-west1"
  description = "The region to deploy to"
}

variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "ssh_key" {
  description = "ssh public key of the user"
  type        = string
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
  type        = number
}

variable "vm_firewall_allow_ip" {
  default     = "0.0.0.0/0"
  description = "number of gke nodes"
  type        = string
}