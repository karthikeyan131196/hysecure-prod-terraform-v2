
# External Network Load Balancer

resource "aws_lb" "external_nlb" {
  name               = "${var.project_name}-external-nlb"
  internal           = false
  load_balancer_type = "network"
  ip_address_type    = "ipv4"

  subnets = [
    aws_subnet.az1a.id,
    aws_subnet.az1b.id
  ]

  enable_cross_zone_load_balancing = true

    tags = merge(local.common_tags, {
    Name = "${var.project_name}-external-lb"
  })
}


# Listener - User-Login (443)

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["https"].arn
  }
}