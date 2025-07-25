variable "project_names" {
  type    = list(string)
#   default = ["challenge"]
}

variable "layers" {
  type    = list(string)
#   default = ["bronze", "prata", "ouro"]
}

variable "project_id" {
  type   = string
}

variable "region" { 
  type = string
}