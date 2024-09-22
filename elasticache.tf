resource "aws_elasticache_cluster" "memcached" {
  count                = var.elasticache_enabled ? 1 : 0
  cluster_id           = "${local.name}-memcached-cluster"
  engine               = "memcached"
  node_type            = var.elasticache_instance_type
  num_cache_nodes      = var.elasticache_nodes
  parameter_group_name = var.elasticache_parameter_group_name
  port                 = var.elasticache_port_number
  subnet_group_name    = aws_elasticache_subnet_group.memcached_subnet_group[count.index].name
  security_group_ids   = [
    aws_security_group.memcached_sg[count.index].id
  ]

  tags = merge(var.default_tags, {
    "Name" = "${local.name}-memcached-cluster"
  })
}

resource "aws_elasticache_subnet_group" "memcached_subnet_group" {
  count      = var.elasticache_enabled ? 1 : 0
  name       = "${local.name}-subnet-group"
  subnet_ids = flatten([module.vpc.private_subnets])

  tags = merge(var.default_tags, {
    "Name" = "${local.name}-subnet-group"
  })
}

resource "aws_security_group" "memcached_sg" {
  count  = var.elasticache_enabled ? 1 : 0
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.elasticache_port_number
    to_port     = var.elasticache_port_number
    protocol    = "tcp"
    cidr_blocks = [ var.vpc_cidr ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = merge(var.default_tags, {
    "Name" = "${local.name}-memcached-security-group"
  })
}
