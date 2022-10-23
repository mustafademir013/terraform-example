# Security Group for ec2 http
module "asg_sec_group" {
  source = "terraform-aws-modules/security-group/aws"

  depends_on = [
    var.vpc_id
  ]
  create = var.asg_create

  name        = "asg_sec_group"
  description = "Security group for ASG"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr_block]
  ingress_rules       = ["http-80-tcp"]
  egress_rules        = ["all-all"]
}
#module auto -scaling group
module "asg" {
  depends_on = [
    module.alb.target_group_arns, module.asg_sec_group.security_group_id
  ]
  source = "terraform-aws-modules/autoscaling/aws"

  create                 = var.asg_create
  create_launch_template = var.asg_create
  # Autoscaling group
  name = "calc-asg"

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = 0
  vpc_zone_identifier       = var.private_subnets

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  target_group_arns = module.alb.target_group_arns
  # Launch template
  launch_template_name        = "calculator-asg-template"
  launch_template_description = "Calculator template"
  update_default_version      = true

  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [module.asg_sec_group.security_group_id]
}