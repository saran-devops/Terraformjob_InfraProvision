provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "external_traffic" {
  name        = "External traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"
  vpc_id      = data.aws_vpc.selected.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Jenkins-Ansible-sg" = "true"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.2xlarge"
  vpc_security_group_ids = [aws_security_group.external_traffic.id]
  subnet_id              = tolist(data.aws_subnets.default_subnets.ids)[0]
  key_name               = "ubuntukey"

  provisioner "remote-exec" {
    inline = [
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get upgrade",
      "sudo apt-get update",
      "sudo apt update",
      "sudo apt install -y openjdk-11-jdk",
      "sudo apt update",
      "sudo apt install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080",
      "sudo sh -c \"iptables-save > /etc/iptables.rules\"",
      "echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections",
      "echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections",
      "sudo apt-get -y install iptables-persistent",
      "sudo ufw allow 8080",
      "java --version",
      "python3 --version",
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
      "sudo apt-get update && sudo apt-get install -y terraform",
      "terraform version",
      "sudo apt-get install -y openjdk-8-jdk",
      "sudo apt update && sudo apt-get install -y python3-pip",
      "sudo pip3 install awscli",
      "sudo pip3 install boto boto3",
      "aws --version",
      "pip --version",
      "python3 --version",
      "python3 -m awscli --version"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/ubuntukey.pem")
  }

  tags = {
    "Name"            = "Jenkins_Master"
    "Jenkins_Ansible" = "true"
  }
}

resource "aws_instance" "ansible" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.external_traffic.id]
  subnet_id              = tolist(data.aws_subnets.default_subnets.ids)[1]
  key_name               = "ubuntukey"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get upgrade",
      "sudo apt-get update",
      "sudo apt update",
      "sudo apt update && sudo apt-get install -y python3-pip",
      "sudo pip3 install awscli",
      "sudo pip3 install ansible",
      "sudo pip3 install boto boto3",
      "aws --version",
      "pip --version",
      "python3 --version",
      "ansible --version",
      "python3 -m awscli --version"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/ubuntukey.pem")
  }

  tags = {
    "Name"    = "Ansible-Controller"
    "Ansible" = "true"
  }
}
