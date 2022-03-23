variable "tags" {
  type        = map(any)
  description = "bucket tag"
  default = {
    environment = "DEV"
    terraform   = "true"
  }
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "vpc_id" {
  type    = string
  default = "vpc-bf097ed4"
}


