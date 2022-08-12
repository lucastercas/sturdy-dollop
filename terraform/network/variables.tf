variable "tags" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "app_name" {
  type = string
}
