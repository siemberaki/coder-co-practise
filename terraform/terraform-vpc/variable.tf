variable "db_password" {
  type        = string
  description = "Password for the WordPress database user"
  sensitive   = true
}