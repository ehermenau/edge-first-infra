# 1. Initiate the Connection from Hub to Edge
resource "aws_vpc_peering_connection" "hub_to_edge" {
  peer_vpc_id = data.terraform_remote_state.edge.outputs.vpc_id
  vpc_id      = module.vpc.vpc_id
  auto_accept = true

  # Enabling DNS resolution across the peering link
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name  = "hub-to-edge-peering"
    Space = "Interconnect"
  }
}

# 2. Hub -> Edge Route (Hub's Private Tables)
resource "aws_route" "hub_to_edge" {
  count                     = length(module.vpc.private_route_table_ids)
  route_table_id            = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block    = data.terraform_remote_state.edge.outputs.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_edge.id
}

# 3. Edge -> Hub Route (Edge's Private Tables - Managed by Hub project)
resource "aws_route" "edge_to_hub" {
  count                     = length(data.terraform_remote_state.edge.outputs.private_route_table_ids)
  route_table_id            = data.terraform_remote_state.edge.outputs.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_edge.id
}
