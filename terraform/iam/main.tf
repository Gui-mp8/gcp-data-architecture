# 1) cria a SA
resource "google_service_account" "sa" {
  account_id   = var.service_account_id
  display_name = var.display_name
}

# 2) gera a chave JSON no formato ADC
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# 3) escreve o arquivo no root do seu repo
 resource "local_file" "sa_key_file" {
  # decodifica o JSON (base64) para obter o arquivo de credenciais completo
   content         = base64decode(google_service_account_key.sa_key.private_key)
   filename        = "${path.root}/credentials-${var.service_account_id}.json"
   file_permission = "0600"
 }

# 4) autentica o gcloud CLI como esta SA
resource "null_resource" "auth_gcloud_cli" {
  depends_on = [local_file.sa_key_file]

  provisioner "local-exec" {
    command     = "gcloud auth activate-service-account --key-file=${local_file.sa_key_file.filename} --project=${var.project_id}"
    interpreter = ["bash", "-c"]
  }
}

# 5) adiciona o export do ADC ao seu ~/.bashrc
resource "null_resource" "export_adc_env" {
  depends_on = [local_file.sa_key_file]

  provisioner "local-exec" {
    command     = <<-EOT
      grep -qxF 'export GOOGLE_APPLICATION_CREDENTIALS=${local_file.sa_key_file.filename}' ~/.bashrc \
        || echo 'export GOOGLE_APPLICATION_CREDENTIALS=${local_file.sa_key_file.filename}' >> ~/.bashrc
    EOT
    interpreter = ["bash", "-c"]
  }
}

# 6) vincula as roles Storage Admin e BigQuery Admin
resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}"
}
