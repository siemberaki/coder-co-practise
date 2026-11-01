variable "my_public_ip_cidr" {
  description = "Your public IP in CIDR notation, allowed to reach the EKS API endpoint (e.g. 203.0.113.10/32)."
  type        = string
  default     = "184.151.230.58/32"
}
