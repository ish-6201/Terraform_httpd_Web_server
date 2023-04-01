# how to user AWS Cloud
terraform {
  required_providers {
    myawscloud = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.61"
    }
  }
}

#Auth to aws cloud
provider "myawscloud" {
  region = "ap-south-1"
  access_key = "AKIA3PB3A3334WQJUY2H"
  secret_key = "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"
}


# manage use resources 
# argument (argumnet reference : key = value)
# Block Name "Resources Type" "Resources Local Name"

variable "OsName"{
  default = "os_web_Terraform"
}

resource "aws_instance" "os1"{
 
  ami = "ami-06e6b44dd2af20ed0" 
  key_name = "key_terraform"
  vpc_security_group_ids = [ "sg-09438b76570b135a2" ]
  instance_type = "t2.micro"
  tags = {
    Name = var.OsName
    }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Ishaan/Downloads/key_terraform.pem")
    host     = aws_instance.os1.public_ip
   }
   provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo touch /var/www/html/index.html",
      "sudo systemctl enable httpd --now"
    ]
  }

}


resource "aws_ebs_volume" "myvol" {
  availability_zone = aws_instance.os1.availability_zone
  size              = 1

  tags = {
    Name = "mywebvol"
  }
}

#Attach Volume to Ec2 instance
resource "aws_volume_attachment" "my_ebs_attach_to_ec2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.myvol.id
  instance_id = aws_instance.os1.id
}

# Attribute References : They are declared after the instances has launched.

output "Public_IP" {
  value = aws_instance.os1.public_ip
}

output "AZ-Zone-Name" {
  value = aws_instance.os1.availability_zone
}

# Now Lets Test the code...


