environment = "production"
infra       = "david-hello-onboarding"

region = "us-east-2"

bootstrap_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC452F8e4GYNUs0beVcJU8aUQPyxY1tSM6uknCp55yytWIH3ljGNbKdnS8AfZ9UxScJt4vrdyueLaGRPCYlDyWGbBPZtSKXqax36imnlE2TrQ81E4gtV3//jxXUjRUnGj3ZidsA3cDWMA/HQPPENF30TxCdjYEfcDrwLMpAQuuCz4DNYbxd3FvwwJVcdBjRelYY0xyhWAdSkNXRbIdtjfjgb9KwmnQO+IsN65Ny2mqRboeDIEULs21KgClFxBWMGIh9FPGQDiXq8/X7yQLmWq51tq48G2FKnzS/6O9e8o5v5yL9/5bTJo8kHZIskfKi02f9SAyubi9qjdZfPAPmRjW+z/sP9X/MF6yBeC2hbodLYDy0rHylkFa3VD0PN53qlGHMjIqTZlTg2WE8HhoKwbPTbLCjpD3CVUGY9zktWgwZNpkdINpu4HEzDsduccn4h8PkiY9YbdUlflta93hrqVCtua4oWnvPdxc+JNtQO4KYwIWvc+56AIdXC8Y4/VGsRLQgqdvVKQ6RaUXG0SU3l8Ay4lQrAEJnxeVH53VbHnzh0D8fkg2c+TyVCeNDogQb99K9sweeuYhP2vtPXGiFcRjoNK9lSU37NiGG3kGn5Lx2TJlD34McLhApk+CYoj+y4do5CQO48Mua6CXxaukdW/DvESlwU+IuEbr6BBlJZj+18Q== davidpoarch@outlook.com"

vpc_cidr = "10.0.0.0/16"

az = ["us-east-2a", "us-east-2b"]

app_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

dmz_subnets = ["10.0.101.0/24", "10.0.102.0/24"]


bastion = {
  instance_type = "t3.medium"
  disk_size     = 30
}

app = {
  instance_type = "t3.medium"
  disk_size     = 30
}


alb_settings = {
  port          = 80
  protocol      = "HTTP"
  interval      = 30
  timeout       = 5
  healthy       = 2
  unhealthy     = 2
  action        = "forward"
  healthy_match = "200,202"
}

app_security_group = {
  ingress = [
    {
      desc     = "SSH from dmz subnet 1",
      from     = 8822,
      to       = 8822,
      protocol = "tcp",
      cidr     = ["10.0.101.0/24"],
    },
    {
      desc     = "SSH from dmz subnet 2",
      from     = 8822,
      to       = 8822,
      protocol = "tcp",
      cidr     = ["10.0.102.0/24"],
    },
    {
      desc     = "HTTP from dmz subnet 1",
      from     = 80,
      to       = 80,
      protocol = "tcp",
      cidr     = ["10.0.101.0/24"],
    },
    {
      desc     = "HTTP from dmz subnet 2",
      from     = 80,
      to       = 80,
      protocol = "tcp",
      cidr     = ["10.0.102.0/24"],
    }
  ],
  egress = [
    {
      desc     = "All sessions allowed out",
      from     = 0,
      to       = 0,
      protocol = "-1",
      cidr     = ["0.0.0.0/0"],
    }
  ]
}

dmz_security_group = {
  ingress = [
    {
      desc     = "SSH from the internet",
      from     = 8822,
      to       = 8822,
      protocol = "tcp",
      cidr     = ["0.0.0.0/0"],
    },
    {
      desc     = "HTTP from the internet",
      from     = 80,
      to       = 80,
      protocol = "tcp",
      cidr     = ["0.0.0.0/0"],
    }
  ],
  egress = [
    {
      desc     = "All sessions allowed out",
      from     = 0,
      to       = 0,
      protocol = "-1",
      cidr     = ["0.0.0.0/0"],
    }
  ]
}
bastion_security_group = {
  ingress = [
    {
      protocol = "tcp",
      from     = 8822,
      to       = 8822,
      cidr     = ["136.158.66.140/32"]
    },
    {
      protocol = "tcp",
      from     = 8822,
      to       = 8822,
      cidr     = ["0.0.0.0/0"]
    },
    {
      from     = -1
      to       = -1
      protocol = "icmp",
      cidr     = ["0.0.0.0/0"]
    }
  ],
  egress = [
    {
      from     = 0,
      to       = 0,
      protocol = -1,
      cidr     = ["0.0.0.0/0"]
    }
  ]
}


database_settings = {
  identifier        = "hello-db"
  name              = "hello_production"
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  engine            = "postgres"
  engine_version    = "13.5"
  parameter_group   = "default.postgresql13"

}

database_security_group = {
  ingress = [
    {
      desc     = "SSH from private subnet 1",
      from     = 22,
      to       = 22,
      protocol = "tcp",
      cidr     = ["10.0.1.0/24"],
      }, {
      desc     = "SSH from private subnet 1",
      from     = 22,
      to       = 22,
      protocol = "tcp",
      cidr     = ["10.0.2.0/24"],
    },
    {
      desc     = "Ping from bastion on",
      from     = 8,
      to       = 0,
      protocol = "icmp",
      cidr     = ["0.0.0.0/0"],
    },
    {
      desc     = "DBS from private subnet 1",
      from     = 5432,
      to       = 5432,
      protocol = "tcp",
      cidr     = ["10.0.1.0/24"],
    },
    {
      desc     = "DBS from private subnet 2",
      from     = 5432,
      to       = 5432,
      protocol = "tcp",
      cidr     = ["10.0.2.0/24"],
  }],
  egress = [
    {
      desc     = "All sessions allowed out",
      from     = 0,
      to       = 0,
      protocol = "-1",
      cidr     = ["0.0.0.0/0"],
    }
  ]
}