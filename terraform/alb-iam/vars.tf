variable "AWS_REGION" {
  type    = string
  default = "us-west-2"
}


variable "SANDBOX_ID" {
  default = "test"
}

variable "env" {
  default = "test"
}

variable "oidc_provider_arn" {
  default = "arn:aws:iam::102305463663:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/3F933DD270F72FD8793701D9130911E7"
}

