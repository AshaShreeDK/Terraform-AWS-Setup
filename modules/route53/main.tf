resource "aws_route53_zone" "private" {
  name = var.private_zone_name
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "servers" {
  count   = 3
  zone_id = aws_route53_zone.private.zone_id
  name    = "server${count.index + 1}.dvstech.com"
  type    = "A"
  ttl     = 300
  records = [element(var.instances, count.index)]
}

