provider "aws" {
  region = var.aws_region
}

#create vpc

resource "aws_vpc" "vpcdemo" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    "Name" = "my-vpc-${var.tags}"
  }
}

# #Create subnet

# resource "aws_subnet" "subnetdemo" {
#   vpc_id     = aws_vpc.vpcdemo.id
#   cidr_block = var.subnet_cidr[count.index]

#   tags = {
#     "Name" = "my-subnet-${var.tags}"
#   }
# }


# Create public subnets

resource "aws_subnet" "public" {
  count             = local.azs
  vpc_id            = aws_vpc.vpcdemo.id
  availability_zone = local.azs_names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  tags = {
    Name       = "public-subnet-${count.index}-${var.tags}"
    Department = "Finance"
  }
}

# Create Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpcdemo.id

  tags = {
    Name = "demo-igw-${var.tags}"
  }
}

# #Create route table 

# resource "aws_route_table" "rtdemo" {
#   vpc_id = aws_vpc.vpcdemo.id

#   route {
#     cidr_block = var.route_cidr
#     gateway_id = aws_internet_gateway.gw.id
#   }


#   tags = {
#     Name = "main-${var.tags}"
#   }
# }

# # Public subnet associations with public route table

# resource "aws_route_table_association" "rtapublic" {
#   count             = local.azs
#   subnet_id      = aws_subnet.public.*.id[count.index]
#   route_table_id = aws_route_table.rtdemo.id
# }

# # Create private subnets

# resource "aws_subnet" "private" {
#   count             = local.azs
#   vpc_id            = aws_vpc.vpcdemo.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, local.azs + count.index)
#   tags = {
#     Name       = "private-subnet-${count.index}-${var.tags}"
#     Department = "Finance"
#   }
# }

# # Elastic IP
# resource "aws_eip" "nat" {
#   vpc      = true
# }

# # Create NAT gateway

# resource "aws_nat_gateway" "gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public.*.id[0]

#   tags = {
#     Name = "nat-gw-${var.tags}"
#   }
# }

# # Public subnet associations with privateroute table

# resource "aws_route_table_association" "rtaprivate" {
#   count             = local.azs
#   subnet_id      = aws_subnet.private.*.id[count.index]
#   route_table_id = aws_route_table.rtdemo.id
# }

