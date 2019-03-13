variable "region" {
  description = "aws region"
  default = "ap-southeast-1"
}

variable "tags" {
  type = "map"
  description = "default tags for all resources"
  default = {}
}

variable "table_name" {
  description = "name of DynamoDB that stores credentials. Default is credential-store"
  default = "credential-store"
}

variable "dynamodb_read_capacity" {
  default = 5
}

variable "dynamodb_write_capacity" {
  default = 1
}




