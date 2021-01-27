variable "aws_region" {
  default = "us-east-1"

}

variable "vpc_cidr" {
  default = "10.0.0.0/16"

}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "tags" {
  default = ""
  type    = string

}

variable "route_cidr" {
  default = "0.0.0.0/0"

}
