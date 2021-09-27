variable "s3_bucket_name" {
  type = string
  description = "The terraform state bucket name"
}

variable "dynamo_db_table_name" {
  type = string
  description = "The terraform state dynamo db table name"
}

variable "folder_state" {
  type = string
  description = "The terraform state bucket folder"
}