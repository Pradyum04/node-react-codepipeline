resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_lb" "alb" {
  name               = "evening-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = []
}

resource "aws_lb_target_group" "tg" {
  name     = "evening-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "evening-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([{
    name      = "app"
    image     = "${var.ecr_repo_url}:latest"
    essential = true
    portMappings = [{ containerPort = 3000 }]
  }])
}

resource "aws_ecs_service" "service" {
  name            = "evening-wali-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "app"
    container_port   = 3000
  }
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "service_name" {
  value = aws_ecs_service.service.name
}