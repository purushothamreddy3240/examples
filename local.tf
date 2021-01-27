data "aws_availability_zones" "available" {
  state = "available"
}
locals {
  azs = length(data.aws_availability_zones.available.names)
  azs_names = data.aws_availability_zones.available.names
}