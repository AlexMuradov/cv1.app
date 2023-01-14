resource "aws_security_group" "cv1" {
  name        = "cv1app-lbs-sg"
  description = "cv1app lbs sg"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "cv1-ecs" {
  name        = "cv1app-ecs-sg"
  description = "cv1app ecs sg"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "cv1" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cv1.id
}

resource "aws_ecs_cluster" "cv1" {
  name = "cv1cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cv1" {
  cluster_name = aws_ecs_cluster.cv1.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "cv1" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn = "arn:aws:iam::225563488370:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::225563488370:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "cv1app"
      image     = "225563488370.dkr.ecr.eu-central-1.amazonaws.com/general-container-registry-1:v1"
      cpu       = 256
      memory    = 512
    
      execution_role_arn = "arn:aws:iam::225563488370:role/ecsTaskExecutionRole" #change
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }]
    }
  ])

}

resource "aws_lb" "cv1" {
  name               = "cv1app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cv1.id]
  subnets            = [for subnet in var.subnet_id : subnet.id]

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "cv1" {
  name        = "cv1app-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "cv1" {
  load_balancer_arn = aws_lb.cv1.arn
  port              = "443"
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cv1.arn
  }
}

resource "aws_ecs_service" "cv1" {
  name            = "cv1app"
  cluster         = aws_ecs_cluster.cv1.id
  task_definition = aws_ecs_task_definition.cv1.arn
  desired_count   = 1
  depends_on = [aws_security_group.cv1-ecs]
  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cv1.id
    container_name   = "cv1app"
    container_port   = 3000
  }

  network_configuration {
    subnets = [for subnet in var.subnet_id : subnet.id]
    security_groups = [aws_security_group.cv1-ecs.id]
    assign_public_ip = true
  }

}

