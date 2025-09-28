output "aws_lb_target_group" {
  value = aws_lb_target_group.tg.arn
}

output "aws_lb_listener" {
  value = aws_lb_listener.http
}

output "alb" {
  value =  aws_lb.alb.arn
}