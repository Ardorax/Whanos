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
