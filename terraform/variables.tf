
variable "environment" {
  type = string
}

variable "infra" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "alb_settings" {
  type = map(any)
}

variable "bootstrap_key" {
  type = string
}

variable "dmz_subnets" {
  type = list(any)
}

variable "app_subnets" {
  type = list(any)
}

variable "dmz_security_group" {
  type = map(any)
}

variable "bastion_security_group" {
  type = map(any)
}


variable "app_security_group" {
  type = map(any)
}

variable "bastion" {
  type = map(any)
}

variable "app" {
  type = map(any)
}

variable "region" {
  type = string
}

variable "az" {
  type = list(any)
}
variable "database_settings" {
  type = map(any)

}
variable "database_security_group" {
  type = map(any)
}
