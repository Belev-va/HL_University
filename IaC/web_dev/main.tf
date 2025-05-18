data "aws_availability_zones" "available" {}

resource "aws_lightsail_instance" "wp_instance" {
  name              = var.instance_name
  blueprint_id      = var.app
  bundle_id         = var.instance_type
  availability_zone = data.aws_availability_zones.available.names[0]
  #user_data         = file("../scripts/bitnami.sh")
  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "06:00"
    status        = "Enabled"
  }
  tags = {
    product = "flure"
    platform = "web"
  }


}

resource "aws_lightsail_static_ip" "wp_static_ip" {
  name = "${var.instance_name}-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "wp_ip_attach" {
  static_ip_name = aws_lightsail_static_ip.wp_static_ip.name
  instance_name  = aws_lightsail_instance.wp_instance.name
}