
variable "alb_create" {
    type = bool
}
variable "asg_create" {
   type = bool
}
variable "vpc_id" {
    type = string
}
variable "vpc_cidr_block" {
    type = string  
}
variable "public_subnets" {
    type = list(string)
}
variable "private_subnets" {
    type = list(string)
}
variable "alb_name" {
  type = string
}
variable "ami" {
  type = string
}
variable "instance_type" {
   type = string
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "desired_capacity" {
  type = number
}
