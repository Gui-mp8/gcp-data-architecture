output "service_account_email" {
  description = "E-mail da Service Account"
  value       = google_service_account.sa.email
}

output "key_file_path" {
  description = "Caminho local do JSON com as credenciais"
  value       = local_file.sa_key_file.filename
}

output "gcloud_cli_auth" {
  description = "ID do recurso que autenticou o gcloud CLI"
  value       = null_resource.auth_gcloud_cli.id
}

output "adc_exported" {
  description = "ID do recurso que adicionou o export a ~/.bashrc"
  value       = null_resource.export_adc_env.id
}
