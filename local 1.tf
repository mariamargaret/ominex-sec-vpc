# locals {
#   subnet_indices = {
#     for idx in range(length(var.subnets.subnet_cidr)) :
#     idx => {
#       cidr = var.subnets.subnet_cidr[idx]
#       name = var.subnets.subnetnames[idx]
#     }
#   }
# }


# locals {
#   subnet_to_route_table = {
#     for idx, subnet in local.subnet_indices :
#     #for idx in local.subnet_indices :
#     idx => {
#       subnet_id      = aws_subnet.FW-MGMT-security[idx].id
#       route_table_id = aws_route_table.pvt-rt["rt${idx + 1}"].id
#     }
#   }
# }


#  Subnet ids

# locals {
#   subnet_ids = {
#     "subnet_id_0" = aws_subnet.FW-MGMT-security[0].id
#     "subnet_id_1" = aws_subnet.FW-MGMT-security[1].id
#     "subnet_id_2" = aws_subnet.FW_MGMT_security[2].id
#     "subnet_id_3" = aws_subnet.FW-MGMT-security[3].id
#     "subnet_id_4" = aws_subnet.FW_MGMT_security[4].id
#     "subnet_id_5" = aws_subnet.FW-MGMT-security[5].id
#     "subnet_id_6" = aws_subnet.FW_MGMT_security[6].id
#     "subnet_id_7" = aws_subnet.FW-MGMT-security[7].id

#     # Add more subnets as needed
#   }
# }

# locals {
#     transitgateway_id = aws_ec2_transit_gateway.sec-tgw.id
# }


locals {
  # Define indices or identifiers for the 6 subnets you want to use
  subnet_indices = [0, 1, 2, 3, 4, 5]

  subnet_to_route_table = {
    for idx in local.subnet_indices : idx => {
      subnet_id      = aws_subnet.FW-MGMT-security[idx].id
      route_table_id = aws_route_table.pvt-rt["rt${idx + 1}"].id
    }
  }
}
