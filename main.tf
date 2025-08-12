resource "aws_instance" "myweb" {
  ami             = "ami-0144277607031eca2"
  instance_type   = "t2.micro"
  key_name        = "aws_tf_key_tranning"
  security_groups = ["my_tf_sg_web_ssh_allow"]

  tags = {
    Name = "Linuxworld web server"
  }
}





resource "aws_ebs_volume" "ebs1" {
  availability_zone = aws_instance.myweb.availability_zone
  size              = 2

  tags = {
    Name = "Linuxworld web server extra volume"
  }
}




resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.ebs1.id
  instance_id = aws_instance.myweb.id
}







resource "null_resource" "nullremote1" {

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.xfs /dev/xvdb",
      "sudo yum install httpd -y",
      "sudo mount /dev/xvdb /var/www/html",
      "sudo sh -c \"echo 'Hii, I am Mohit Sharma' > /var/www/html/index.html\"",
      "sudo systemctl restart httpd"
    ]
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:\\Users\\Lenovo\\Downloads\\aws_tf_key_tranning.pem")
    host        = aws_instance.myweb.public_ip
  }
}




resource "null_resource" "nullremotechrome" { 
  provisioner "local-exec" {
    command = "chrome http://${aws_instance.myweb.public_ip}/"
  }
}
