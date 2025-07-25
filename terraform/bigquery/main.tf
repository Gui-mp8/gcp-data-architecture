resource "google_bigquery_dataset" "multi_tiered" {
  for_each = { for d in local.dataset_combinations : d.dataset_id => d }

  project                     = var.project_id
  dataset_id                  = each.value.dataset_id
  location                    = var.region
  description                 = "Dataset `${each.value.layer}` for project `${each.value.project_id}`"
  default_table_expiration_ms = 3600000
  delete_contents_on_destroy  = true

  labels = {
    environment = "default"
    tier        = each.value.layer
  }
}

resource "google_bigquery_table" "tables" {
  for_each = {
    for combo in local.table_combinations :
    "${combo.dataset_id}_${combo.table_name}" => combo
  }

  project    = var.project_id
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_name

  schema = file(each.value.schema_path)

}