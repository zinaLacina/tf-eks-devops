variable "provider_env_roles" {
  type    = map(string)
  default = {
    "hubint"     = ""
    "hubqa"    = "arn:aws:iam::<AWS_ACCOUNT_2>:role/<ROLE_NAME>"
    "hubprod"     = ""
  }
}

variable "deployment-region" {
  type = string
  default = "us-east-2"
}

variable "cluster_name" {
  type = string
  description = "The cluster name"
}

variable "vpc_name" {
  type = string
  description = "The vpc name"
}

variable "pager_duty_endpoint" {
  type = string
  description = "The pager_duty_endpoint name"
}

variable "sns_pager_duty_topic" {
  type = string
  description = "The sns_pager_duty_topic name"
}

variable "sns_slack_topic" {
  type = string
  description = "The sns_slack_topic name"
}

variable "slack_webhook_url" {
  type = string
  description = "The slack_webhook_url name"
}

variable "state_bucket" {
  type = string
  description = "The bucket name of tf state"
}

variable "key_folder_state" {
  type = string
  description = "The key of tf state"
}

variable "state_dynamo_table" {
  type = string
  description = "The dynamo table of tf state"
}