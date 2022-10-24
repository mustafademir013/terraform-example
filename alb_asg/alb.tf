
module "alb_sec_group" {
  source = "terraform-aws-modules/security-group/aws"

  depends_on = [
    var.vpc_id
  ]

  create = var.alb_create

  name        = "alb-sec-group"
  description = "Security group for with ALB"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]
  tags = var.tags
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  depends_on = [
    module.alb_sec_group.security_group_id
  ]

  create_lb = var.alb_create

  name = var.alb_name

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [module.alb_sec_group.security_group_id]

  target_groups = [
    {
      name_prefix      = "calc-"
      backend_protocol = "HTTP"
      backend_port     = 80
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = var.tags
}



