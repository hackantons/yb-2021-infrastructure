resource "aws_alb" "ybhackathon" {
  name               = "alb-ybhackathon-2021"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_ybhackathon.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    environment = "production"
  }
}

resource "aws_security_group" "alb_ybhackathon" {
  name        = "alb-ybhackathon-2021"
  description = "Allow ybhackathon"
  vpc_id      = aws_vpc.ybhackathon_vpc.id

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
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
    Name = "allow_internet"
  }
}

resource "aws_alb_target_group" "ybhackathon" {
  name        = "ybhackathon-2021"
  protocol    = "HTTP"
  port        = "3000"
  vpc_id      = aws_vpc.ybhackathon_vpc.id
  target_type = "ip"

  health_check {
    path = "/api/health/ready"
  }
}

resource "aws_alb_listener" "backend" {
  load_balancer_arn = aws_alb.ybhackathon.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.ybhackathon.id
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "ybhackathon-backend" {
  listener_arn = aws_alb_listener.backend.arn
  priority     = 100
  action {
    target_group_arn = aws_alb_target_group.ybhackathon.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = ["backend.bscyb.dev"]
    }
  }
}
