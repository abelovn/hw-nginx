variable "yc_token" {
  type = string
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_zones" {
  type = list(string)
}

variable "yc_subnets" {
  type = list(list(string))
}
