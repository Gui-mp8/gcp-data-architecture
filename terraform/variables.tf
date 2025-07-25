variable "project_id" { 
  type = string
  default = "data-arch-challenge"
}
variable "region" { 
  type = string
  default = "us-central1"
}
variable "bucket_location" { 
  type = string
  default = "us-central1"
}
variable "bucket_name" { 
  type = string
  default = "challenge_raw"
}
variable "project_names" { 
  type    = list(string)
  default = ["challenge"]
}
variable "layers" { 
  type    = list(string)
  default = ["bronze", "prata", "ouro"]
}