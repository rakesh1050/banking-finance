resource "aws_instance" "test-server" {
  ami = "ami-04a37924ffe27da53"
  instance_type = "t2.micro"
  key_name = "Jenkins"
  vpc_security_group_ids = ["sg-05496cb3a3f0026a8"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./Jenkins.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/banking-finance/terraform-files/ansibleplaybook.yml"
     }
  }
