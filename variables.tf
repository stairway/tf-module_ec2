variable "instance_type" {
  default = {
    default = "t2.micro"
    dev = "t2.nano"
    prod ="t2.large"
  }
  
  type = map
}