resource "aws_key_pair" "k8s" {
  key_name   = "k8s-key"
  public_key = file("~/.ssh/my-key.pub")
}

resource "aws_instance" "k8s_master" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name               = aws_key_pair.k8s.key_name
  user_data              = file("${path.module}/../scripts/install-k8s.sh")
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "k8s_worker" {
  count                  = 2
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name               = aws_key_pair.k8s.key_name
  user_data              = file("${path.module}/../scripts/configure-nodes.sh")
  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }
}
