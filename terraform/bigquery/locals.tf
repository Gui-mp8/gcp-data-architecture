locals {
  # 1) all combinations of project × layer
  dataset_combinations = flatten([
    for proj in var.project_names : [
      for lyr in var.layers : {
        project_id = proj
        layer      = lyr
        dataset_id = "${proj}_${lyr}"
      }
    ]
  ])

  # 2) list of JSON schemas under ./schemas
  schema_files = fileset("${path.module}/schemas", "*.json")

  # 3) map table_name → filesystem path of JSON schema
  table_schemas = {
    for file in local.schema_files :
    replace(file, ".json", "") => "${path.module}/schemas/${file}"
  }

  # 4) flatten into one list of (project, layer, dataset, table, schema_path)
  table_combinations = flatten([
    for ds in local.dataset_combinations : [
      for tbl, schema_path in local.table_schemas : {
        project_id  = ds.project_id
        layer       = ds.layer
        dataset_id  = ds.dataset_id
        table_name  = tbl
        schema_path = schema_path
      }
    ]
  ])
}
