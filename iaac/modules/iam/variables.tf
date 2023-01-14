# Input variable definitions

variable "cidr" {
  description = "VPC CIDR block address."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Tags to set on the bucket."
  type        = number
  default     = 3
}

variable "subnet_cidr" {
  description = "Tags to set on the bucket."
  type        = number
  default     = 24
}
