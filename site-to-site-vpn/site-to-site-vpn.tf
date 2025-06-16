# Define the transit gateway name as a local variable
locals {
  transit_gw_name = "aws-tg-vendors-tgw"
}

module "site-to-site-vpn" {
  source = "git::ssh://git@github.com/madeesha/aws-modules//terraform-aws-site-to-site-vpn/site-to-site-vpn?ref=main"
  
  # Use for_each to create multiple VPN connections for HA
  for_each = local.customer_gateways
  
  # Use the merged configuration from locals for each gateway
  # For legacy configs, use the original name; for new configs, use the generated name
  name                                 = local.is_legacy_config ? each.value.name : each.value.name
  customer_gateway_ip_address          = each.value.customer_gateway_ip_address
  bgp_asn                              = each.value.bgp_asn
  type                                 = each.value.type
  static_routes_only                   = each.value.static_routes_only
  tunnel1_ike_versions                 = each.value.tunnel1_ike_versions
  tunnel1_startup_action               = each.value.tunnel1_startup_action
  tunnel1_phase1_dh_group_numbers      = each.value.tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = each.value.tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = each.value.tunnel1_phase1_integrity_algorithms
  tunnel1_phase2_dh_group_numbers      = each.value.tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = each.value.tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = each.value.tunnel1_phase2_integrity_algorithms
  tunnel2_ike_versions                 = each.value.tunnel2_ike_versions
  tunnel2_startup_action               = each.value.tunnel2_startup_action
  tunnel2_phase1_dh_group_numbers      = each.value.tunnel2_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms = each.value.tunnel2_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = each.value.tunnel2_phase1_integrity_algorithms
  tunnel2_phase2_dh_group_numbers      = each.value.tunnel2_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = each.value.tunnel2_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = each.value.tunnel2_phase2_integrity_algorithms
}