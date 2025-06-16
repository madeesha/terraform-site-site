locals {
  # Get the current workspace name, defaulting to "default" if not using workspaces
  workspace = terraform.workspace

  # Define common configuration that applies to all clients
  common_config = {
    bgp_asn                              = 65000
    type                                 = "ipsec.1"
    static_routes_only                   = true
    tunnel1_ike_versions                 = ["ikev1", "ikev2"]
    tunnel1_startup_action               = "add"
    tunnel1_phase1_dh_group_numbers      = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
    tunnel1_phase1_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
    tunnel1_phase1_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
    tunnel1_phase2_dh_group_numbers      = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
    tunnel1_phase2_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
    tunnel1_phase2_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
    tunnel2_ike_versions                 = ["ikev1", "ikev2"]
    tunnel2_startup_action               = "add"
    tunnel2_phase1_dh_group_numbers      = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
    tunnel2_phase1_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
    tunnel2_phase1_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
    tunnel2_phase2_dh_group_numbers      = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
    tunnel2_phase2_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
    tunnel2_phase2_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
  }

  # Check if a YAML file exists for the current workspace
  client_yaml_exists = fileexists("${path.module}/clients/${terraform.workspace}.yaml")
  
  # Load the client configuration directly from the workspace-named YAML file if it exists
  current_client_config = local.client_yaml_exists ? yamldecode(file("${path.module}/clients/${terraform.workspace}.yaml")) : {}

  # Determine if this is a legacy single gateway config or new multi-gateway config
  is_legacy_config = can(local.current_client_config.customer_gateway_ip_address)
  
  # Create customer gateway configurations
  # For non HA configs, create a single gateway
  # For HA cofigs, creates multiple gateways
  customer_gateways = local.is_legacy_config ? {
    "gateway-1" = merge(local.common_config, local.current_client_config)
  } : {
    for idx, gateway in local.current_client_config.customer_gateways : 
    "gateway-${idx + 1}" => merge(local.common_config, gateway, {
      name = "${local.current_client_config.name}-${idx + 1}"
    })
  }
  config = merge(local.common_config, local.current_client_config)
}
