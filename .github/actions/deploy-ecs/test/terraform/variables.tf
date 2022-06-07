variable "TFC_WORKSPACE_NAME" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "service_role_codedeploy_arn" {
  type    = string
  default = "arn:aws:iam::977320448514:role/ecsCodeDeployRole"
}
