#Author: Alexandru Raul
### Variables ###

#AWS region
variable "region" {
   type = string
   default = "us-west-2"
   description = "Region"
}
#End

#AWS profile
variable "profile" {
   type        = string
   description = "Account profile"
}
#End

#VPC Name
variable "vpc_name" {
   type = string
   description = "VPC Name"
}
#End

#Network requirements

#VPC Ciddr
variable "vpc_ciddr" {
   type = string
   description = "VPC CIDDR block"
}
#End

#Public subnets
variable "public_subnets" {
  description = "Public subnets"
  type        = map(object({
    cidr_block          = string
    availability_zone   = string
    map_public_ip_on_launch = bool
    route_table_name    = string
  }))
}
#End Public subnets

#Private subnets
variable "private_subnets" {
  description = "Private subnets"
  type        = map(object({
    cidr_block          = string
    availability_zone   = string
    map_public_ip_on_launch = bool
    route_table_name    = string
  }))
}
#End Private subnets

variable "nat_gateway_subnet" {
  description = "Subnet to associate the NAT gateway with"
  type        = string
  default     = "subnet1"
}
#End Network requirements

#Tagging
#Business TAGS
variable "business_tags" {
   description = "Business TAGS"
  type    = map
  default = {
    "atos:business:project"                 = "ceb development- aws backup on aws"
    "atos:business:owner"                   = "ceb team"
    "atos:business:charge_to_id"            = "ChargeID-BBSC"
    "atos:business:businessunit"            = "businessunit"
    "atos:business:WBS"                     = "wbs"
    "atos:business:stakeholder"             = "ceb team"
    "atos:business:impact"                  = "low"
    "atos:business:dedicated:client_name"   = "Client Name"
    "atos:business:dedicated:country"       = "UK/DE"

  }
}
#End Business TAGS

#VPC technical TAGS
variable "technical_vpc_tags" {
   description = "VPC Technical TAGS"
  type    = map
  default = {
    "atos:vpc:technical:stack"                 = "development"
    "atos:vpc:technical:deployment_method"     = "terraform"
    "atos:vpc:technical:connectivity_type"     = "hybrid"
    "atos:vpc:technical:flow_logs"             = "disabled"
    "atos:vpc:technical:vpn_connection"        = "disabled"
    "atos:vpc:technical:peering"               = "disabled"

   }
}


#Private subnet technical TAGS
variable "technical_vpc_private_subnet_tags" {
   description = "VPC private subnets technical TAGS"
  type    = map
  default = {
    "atos:vpc:subnet:private:technical:stack"                 = "development"
    "atos:vpc:subnet:private:technical:deployment_method"     = "terraform"
    "atos:vpc:subnet:private:technical:connectivity_type"     = "private"
    "atos:vpc:subnet:private:technical:nat"                   = "nat gateway"
   }
}
#End Private subnet technical TAGS


#Public subnet technical TAGS
variable "technical_vpc_public_subnet_tags" {
   description = "VPC public subnets technical TAGS"
  type    = map
  default = {
    "atos:vpc:subnet:public:technical:stack"                 = "development"
    "atos:vpc:subnet:public:technical:deployment_method"     = "terraform"
    "atos:vpc:subnet:public:technical:connectivity_type"     = "public"
    "atos:vpc:subnet:public:technical:internet_gateway"      = "enabled"
   }
}
#End Public subnet technical TAGS

#End VPC technical TAGS


#VPC security TAGS
variable "security_tags" {
   description = "Security TAGS"
  type    = map
  default = {
    "atos:security:compliance"             = "none"
    "atossecurity:classification"          = "restricted"
    "atos:security:encryption"             = "encrypted"
    "atos:security:level"                  = "medium"
    "atos:security:incident_response"      = "security team"
    "atos:security:access_control"         = "private access"

  }
}
#End VPC security TAGS


#End
