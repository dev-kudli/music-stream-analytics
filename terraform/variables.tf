variable "project" {
  description = "Your GCP Project ID"
  default     = "music-stream-analytics"
  type        = string
}

variable "region" {
  description = "Your project region"
  default     = "northamerica-northeast1"
  type        = string
}

variable "zone" {
  description = "Your project zone"
  default     = "northamerica-northeast1-a"
  type        = string
}

variable "storage_class" {
  description = "Storage class type for your bucket"
  default     = "STANDARD"
  type        = string
}

variable "vm_image" {
  description = "Image for you VM"
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
  type        = string
}

variable "network" {
  description = "Network for your instance/cluster"
  default     = "default"
  type        = string
}

variable "stg_bq_dataset" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default     = "streamify_stg"
  type        = string
}

variable "prod_bq_dataset" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default     = "streamify_prod"
  type        = string
}

variable "bucket" {
  description = "The name of your bucket. This should be unique across GCP"
  default     = "music-stream-analytics"
  type        = string
}

variable "credentials" {
  description = "GCP key file"
  default     = "../google_credentials.json"
}