variable "region" {
  default = "eu-west-2"
} 

variable "profile" {
  default = null
}

variable "project_name" {
  default = "loki-stack"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.198.0.0/16"
}

variable "elasticache_enabled" {
  type    = bool
  default = false
}

