resource "aws_eip" "bastion-eip" {
  instance = aws_instance.bastion.id
  vpc      = true
  tags = {
    Name = "bastion-eip-${var.environment}"
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = var.bastion.instance_type
  key_name               = aws_key_pair.bootstrap-key.id
  subnet_id              = aws_subnet.dmz.*.id[0]
  security_groups        = [aws_security_group.bastion-sg.id]
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  user_data              = file("instance-init.sh")
  root_block_device {
    volume_size = var.bastion.disk_size
  }
  tags = {
    Name = "${var.infra}-${var.environment}-bastion"
  }
  lifecycle {
    ignore_changes = [ami, user_data, security_groups]
  }
}