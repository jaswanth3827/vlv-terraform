output "alb_security_group_id" {
    value = aws_security_group.alb_security_group.id
}
output "author_security_group_id" {
    value = aws_security_group.author_security_group.id
}
output "publish_security_group_id" {
    value = aws_security_group.publish_security_group.id
}
output "dispatcher_security_group_id" {
    value = aws_security_group.dispatcher_security_group.id
}

