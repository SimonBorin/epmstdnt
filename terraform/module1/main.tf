//provider "docker" {
//  host = "tcp://127.0.0.1:2375/"
//}
//
//resource "docker_image" "nginx" {
//  name = var.nginx
//}
//
//resource "docker_image" "php" {
//  name = var.php
//}
//
//resource "docker_container" "nginx" {
//  name  = "nginx-module1"
//  image = docker_image.nginx.name
////  command = ["nginx", "-g", "daemon off;"]
//  volumes {
//    host_path = "/my_stuff/DevOps/epmstdnt/terraform/docker/files/default.conf"
//    container_path = "/etc/nginx/conf.d/"
//  }
//  ports {
//    internal = 80
//    external = 8080
//  }
//  networks_advanced {
//    name = docker_network.private_network.name
//  }
//}
//
//resource "docker_container" "php" {
//  name  = "php-mosule1"
//  image = docker_image.php.name
//  volumes {
//    host_path = "/my_stuff/DevOps/epmstdnt/terraform/docker/files/index.php"
//    container_path = "/index.php"
//  }
//  networks_advanced {
//    name = docker_network.private_network.name
//  }
//}
//
//resource "docker_network" "private_network" {
//  name = var.docker-net
//}