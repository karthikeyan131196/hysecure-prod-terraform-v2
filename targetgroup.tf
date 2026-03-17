############################################
# TARGET GROUPS
############################################

locals {
  target_groups = {
    https = {
      port     = 443
      protocol = "TCP"
      health = {
        protocol = "HTTPS"
        path     = "/hapage.html"
        port     = "443"
      }
    }

    db = {
      port     = 3306
      protocol = "TCP"
      health = {
        protocol = "TCP"
        port     = "3306"
      }
    }

    info = {
      port     = 939
      protocol = "TCP"
      health = {
        protocol = "HTTPS"
        path     = "/statuscheck"
        port     = "443"
      }
    }
  }
}

############################################
# CREATE TARGET GROUPS (LOOP)
############################################

resource "aws_lb_target_group" "tg" {
  for_each = local.target_groups

  name        = "${var.project_name}-tg-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = "ip"

  vpc_id = aws_vpc.hysecure_vpc.id

  dynamic "health_check" {
    for_each = [each.value.health]

    content {
      protocol = health_check.value.protocol
      port     = health_check.value.port

      path = lookup(health_check.value, "path", null)

      healthy_threshold   = 5
      unhealthy_threshold = 2
      interval            = 30
      timeout             = 5
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-tg-${each.key}"
  })
}

############################################
# ATTACHMENTS - HTTPS (ALL NODES)
############################################

resource "aws_lb_target_group_attachment" "https" {
  for_each = aws_instance.nodes

  target_group_arn = aws_lb_target_group.tg["https"].arn
  target_id        = each.value.private_ip
  port             = 443
}

############################################
# ATTACHMENTS - DB (ONLY active + standby)
############################################

resource "aws_lb_target_group_attachment" "db" {
  for_each = {
    for k, v in aws_instance.nodes :
    k => v if contains(["active","standby"], k)
  }

  target_group_arn = aws_lb_target_group.tg["db"].arn
  target_id        = each.value.private_ip
  port             = 3306
}

############################################
# ATTACHMENTS - INFO (ONLY active + standby)
############################################

resource "aws_lb_target_group_attachment" "info" {
  for_each = {
    for k, v in aws_instance.nodes :
    k => v if contains(["active","standby"], k)
  }

  target_group_arn = aws_lb_target_group.tg["info"].arn
  target_id        = each.value.private_ip
  port             = 939
}
