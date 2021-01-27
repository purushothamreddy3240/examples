# Create Ec2 instance

# resource "aws_instance" "instancedemo" {
#   ami                         = "ami-0be2609ba883822ec"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.sgdemo.id]
#   subnet_id                   = aws_subnet.public.*.id[0]
#   user_data                   = file("apache.sh")
#   key_name                    = "new"

#   tags = {
#     "Name" = "myinstance-${var.tags}"
#   }

# }

#Create security group

resource "aws_security_group" "sgdemo" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpcdemo.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysg-${var.tags}"
  }
}

# #Create Rds 

# resource "aws_db_instance" "mydemo" {
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "mydb"
#   username             = "reddy"
#   password             = "reddy123"
#   parameter_group_name = "mydemo.mysql5.7"
# }

resource "aws_launch_configuration" "my_lc" {
  name_prefix     = "terraform-lc"
  image_id        = "ami-0be2609ba883822ec"
  instance_type   = "t2.micro"
  key_name        = "new"
  user_data       = file("apache.sh")
  security_groups = [aws_security_group.sgdemo.id]
}


resource "aws_launch_template" "mytemplate" {
  name                   = "mytemplate"
  image_id               = "ami-0be2609ba883822ec"
  instance_type          = "t2.micro"
  key_name               = "new"
  vpc_security_group_ids = [aws_security_group.sgdemo.id]
  

    tags = {
      "Name" = "demotemplate"
    }
}

# Create load balancer

resource "aws_lb" "demolb" {
  name               = "demo-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id

  tags = {
    Environment = "production"
  }
}

# Create autoscaling group

resource "aws_autoscaling_group" "demoasg" {

  name                      = "terraform-test"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier       = aws_subnet.public.*.id
  
  launch_template {
    id      = aws_launch_template.mytemplate.id
    version = aws_launch_template.mytemplate.latest_version
  }

  tag {
    key                 = "Name"
    value               = "demo"
    propagate_at_launch = true
  }
}  


