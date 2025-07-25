variable "project_id" {
  description = "ID do projeto GCP onde a SA será criada"
  type        = string
}

variable "region" {
  description = "Região padrão (só usada no provider, BigQuery/GCS não dependem disso diretamente)"
  type        = string
  default     = "us-central1"
}

variable "service_account_id" {
  description = "Identificador da SA (parte antes de @)"
  type        = string
}

variable "display_name" {
  description = "Nome amigável da Service Account"
  type        = string
}

variable "roles" {
  description = <<-EOF
    Lista de roles que a SA receberá no projeto.
    Exemplo:
      ["roles/storage.admin", "roles/bigquery.admin"]
  EOF
  type = list(string)
}