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
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "yc_subnets" {
  type = list(list(string))
  default = [
      ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], 
      ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"], 
      ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
    ]
}
