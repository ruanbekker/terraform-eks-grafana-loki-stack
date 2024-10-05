
variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Name to identify the project name in tags, descriptions, etc."
  default     = "loki-stack"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to be applied to resources."
  default = {}
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR."
  default     = "10.0.0.0/16"
}

variable "eks_version" {
  type        = string
  description = "EKS version."
  default     = "1.29"
}

variable "eks_instance_type" {
  type        = string
  description = "EKS instance types."
  default     = "t3.medium"
}

variable "eks_capacity_type" {
  type        = string
  description = "Capacity type (ON_DEMAND, SPOT)."
  default     = "ON_DEMAND"
}

variable "eks_desired_size" {
  type        = number
  description = "The asg desired size value."
  default     = 3
}

variable "eks_max_size" {
  type        = number
  description = "The asg max size value."
  default     = 5
}

variable "eks_min_size" {
  type        = number
  description = "The asg min size value."
  default     = 3
}

variable "eks_workers_iam_policies" {
  description = "IAM policies to be associated to the workers."
  type        = map(string)
  default = {
    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }
}

variable "elasticache_enabled" {
  type        = bool
  description = "Deploys and use elasticache memcached for loki cache."
  default     = false
}

variable "elasticache_instance_type" {
  type        = string
  description = "The elasticache instance type."
  default     = "cache.t3.small"
}

variable "elasticache_nodes" {
  type        = number
  description = "The number of cache nodes in elasticache."
  default     = 1
}

variable "prometheus_namespace" {
  type        = string
  description = "The namespace where prometheus should be deployed."
  default     = "observability"
}

variable "elasticache_parameter_group_name" {
  type        = string
  description = "The elasticache parameter group name."
  default     = "default.memcached1.6"
}

variable "elasticache_port_number" {
  type        = number
  description = "The elasticache port number."
  default     = 11211
}

variable "loki_namespace" {
  type        = string
  description = "The namespace where loki should be deployed."
  default     = "observability"
}

variable "promtail_namespace" {
  type        = string
  description = "The namespace where promtail should be deployed."
  default     = "observability"
}

variable "loki_log_retention" {
  type        = string
  description = "The grafana loki log retention in hours."
  default     = "720h"
}

variable "promtail_release_name" {
  type        = string
  description = "The grafana promtail helm release name."
  default     = "grafana-promtail"
}

variable "loki_release_name" {
  type        = string
  description = "The grafana loki helm release name."
  default     = "grafana-loki"
}

variable "prometheus_release_name" {
  type        = string
  description = "The prometheus helm release name."
  default     = "kube-prometheus-stack"
}

// Versions
variable "prometheus_version" {
  type        = string
  description = "The kube prometheus stack helm chart version."
  default     = "61.7.0"
}

variable "promtail_version" {
  type        = string
  description = "The grafana promtail helm chart version."
  default     = "6.16.4"
}

variable "loki_version" {
  type        = string
  description = "The kube prometheus stack helm chart version."
  default     = "6.7.1"
}
