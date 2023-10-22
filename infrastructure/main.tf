terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}

resource "digitalocean_droplet" "proxy" {
  count  = 2 
  image  = "ubuntu-20-04-x64"
  name   = "proxy-${count.index}"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  user_data = <<-EOF
  #!/bin/bash
  sudo apt install nodejs -y
  sudo apt install npm -y
  sudo npm cache clean -f
  sudo npm install -g n
  sudo n stable
  npm install -g pm2
  cd /home && mkdir proxy && cd proxy
  git clone https://gist.github.com/EsteveSegura/1bfdc6ea1762a00e3baa5b5487370466
  cd /home/proxy/1bfdc6ea1762a00e3baa5b5487370466
  pm2 start proxy.js
  pm2 startup systemd
  pm2 save
  EOF
}

resource "null_resource" "output_ips_to_file" {
  provisioner "local-exec" {
    command = "echo '${join("\n", digitalocean_droplet.proxy[*].ipv4_address)}' > ip_addresses.txt"
  }
}