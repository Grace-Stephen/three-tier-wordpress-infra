variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names (SANs)"
  type        = list(string)
  default     = []
}

#