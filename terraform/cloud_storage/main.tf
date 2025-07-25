resource "google_storage_bucket" "raw_bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true
  uniform_bucket_level_access = true

  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
}