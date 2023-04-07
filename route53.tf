resource "aws_route53_zone" "host-zone" {
  name = "jyotioffset.ml"
}

resource "aws_route53_record" "test_record" {
  zone_id = aws_route53_zone.host-zone.id
  name    = "www.jyotioffset.ml"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.server.public_ip]
}
