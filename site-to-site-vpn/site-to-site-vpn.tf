# Define the transit gateway name as a local variable
locals {
  transit_gw_name = "aws-tg-vendors-tgw"
}

module "site-to-site-vpn" {
    source = "git::ssh://git@github.com/madeesha/aws-modules//terraform-aws-site-to-site-vpn/site-to-site-vpn?ref=main"
    
    
    # Use the merged configuration from locals
    name                                 = local.config.name
    customer_gateway_ip_address          = local.config.customer_gateway_ip_address
    bgp_asn                              = local.config.bgp_asn
    type                                 = local.config.type
    static_routes_only                   = local.config.static_routes_only
    tunnel1_ike_versions                 = local.config.tunnel1_ike_versions
    tunnel1_startup_action               = local.config.tunnel1_startup_action
    tunnel1_phase1_dh_group_numbers      = local.config.tunnel1_phase1_dh_group_numbers
    tunnel1_phase1_encryption_algorithms = local.config.tunnel1_phase1_encryption_algorithms
    tunnel1_phase1_integrity_algorithms  = local.config.tunnel1_phase1_integrity_algorithms
    tunnel1_phase2_dh_group_numbers      = local.config.tunnel1_phase2_dh_group_numbers
    tunnel1_phase2_encryption_algorithms = local.config.tunnel1_phase2_encryption_algorithms
    tunnel1_phase2_integrity_algorithms  = local.config.tunnel1_phase2_integrity_algorithms
    tunnel2_ike_versions                 = local.config.tunnel2_ike_versions
    tunnel2_startup_action               = local.config.tunnel2_startup_action
    tunnel2_phase1_dh_group_numbers      = local.config.tunnel2_phase1_dh_group_numbers
    tunnel2_phase1_encryption_algorithms = local.config.tunnel2_phase1_encryption_algorithms
    tunnel2_phase1_integrity_algorithms  = local.config.tunnel2_phase1_integrity_algorithms
    tunnel2_phase2_dh_group_numbers      = local.config.tunnel2_phase2_dh_group_numbers
    tunnel2_phase2_encryption_algorithms = local.config.tunnel2_phase2_encryption_algorithms
    tunnel2_phase2_integrity_algorithms  = local.config.tunnel2_phase2_integrity_algorithms
}

