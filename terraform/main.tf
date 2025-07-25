terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "17.0.0"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = true

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "bigquery.googleapis.com"
  ]
}

module "raw_bucket" {
  source = "./cloud_storage"
  bucket_name = var.bucket_name
  location = var.bucket_location
}

module "bigquery" {
  source = "./bigquery"
  project_names = var.project_names
  layers = var.layers
  project_id = var.project_id
  region = var.region
}