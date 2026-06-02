locals {
  target_groups = {
    https = {
      port            = 443
      protocol        = "TCP"
      health_protocol = "HTTPS"
      health_path     = "/hapage.html"
      health_port     = 443
    }

    db = {
      port            = 3306
      protocol        = "TCP"
      health_protocol = "HTTPS"
      health_path     = "/statuscheck"
      health_port     = 443
    }

    info = {
      port            = 939
      protocol        = "TCP"
      health_protocol = "HTTPS"
      health_path     = "/statuscheck"
      health_port     = 443
    }
  }
}

# CREATE TARGET GROUPS

resource "aws_lb_target_group" "tg" {
  for_each = local.target_groups

  name        = "${var.project_name}-tg-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = "ip"
  vpc_id      = local.vpc_id

  health_check {
    protocol            = each.value.health_protocol
    port                = each.value.health_port
    path                = each.value.health_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-tg-${each.key}"
  })
}

# FILTER ACTIVE + STANDBY

locals {
  internal_nodes = {
    for k, v in aws_instance.nodes :
    k => v if contains(["active", "standby"], k)
  }
}

# ATTACHMENTS - HTTPS (ALL NODES)

resource "aws_lb_target_group_attachment" "https" {
  for_each = aws_instance.nodes

  target_group_arn = aws_lb_target_group.tg["https"].arn
  target_id        = each.value.private_ip
  port             = 443
}

# ATTACHMENTS - DB (ONLY active + standby)

resource "aws_lb_target_group_attachment" "db" {
  for_each = local.internal_nodes

  target_group_arn = aws_lb_target_group.tg["db"].arn
  target_id        = each.value.private_ip
  port             = 3306
}

# ATTACHMENTS - INFO (ONLY active + standby)

resource "aws_lb_target_group_attachment" "info" {
  for_each = local.internal_nodes

  target_group_arn = aws_lb_target_group.tg["info"].arn
  target_id        = each.value.private_ip
  port             = 939
}