# Internal Network Load Balancer

resource "aws_lb" "internal_nlb" {
  name               = "${var.project_name}-internal-nlb"
  internal           = true
  load_balancer_type = "network"
  ip_address_type    = "ipv4"

  subnets = [
    local.subnet_az1a_id,
    local.subnet_az1b_id
  ]

  enable_cross_zone_load_balancing = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-internal-lb"
  })
}

# Listener - Database (3306)

resource "aws_lb_listener" "listener_db" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = 3306
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["db"].arn
  }
}

# Listener - Info Agent (939)

resource "aws_lb_listener" "listener_info" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = 939
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["info"].arn
  }
}