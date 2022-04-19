


variable "aws_instance_type" {
    type = string
    default = "t2.micro"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-2"
}

variable "aws_allow_cidr_range" {
    type = string
    default = "0.0.0.0/0"
}

variable "aws_sshuser" {
    type = string
    default = "centos"
}

variable "aws_privatekeypath" {
    type = string
    default = ""
}

variable "aws_keyname" {
    type = string
    default = ""
}
variable "amifilter_osname" {
    type = string
    default = "CentOS 7.9*"
}

variable "amifilter_osarch" {
    type = string
    default = "x86_64"
}

variable "amifilter_osvirtualizationtype" {
    type = string
    default = "hvm"
}

variable "amifilter_owner" {
    type = string
    default = "125523088429" # CentOS 7.9
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default = ""
}

variable "client_id" {
  type        = string
  description = "Azure Client ID"
  default = ""
}

variable "client_secret" {
  type        = string
  description = "Azure Client secret"
  sensitive   = true
  default = ""
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
  default = ""
}

variable "az_ssh_pubkey" {
  type        = string
  description = "Public key for SSH access"
  default = ""
}