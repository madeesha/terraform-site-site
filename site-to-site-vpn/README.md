# Terraform AWS Site-to-Site VPN

This Terraform module deploys AWS Site-to-Site VPN connections using Terraform workspaces to manage different client configurations.

## Architecture

This module uses Terraform workspaces to manage different client configurations (like Alinta and Tally) dynamically, instead of hardcoding backend keys and var files. The state files are stored in S3 with workspace-specific paths.

## Prerequisites

- Terraform >= 0.14
- AWS CLI configured with appropriate permissions
- Access to the S3 bucket for state storage

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Create or Select a Workspace

Create a new workspace for a client:

```bash
terraform workspace new <client_name>
```

Or select an existing workspace:

```bash
terraform workspace select <client_name>
```

Available workspaces:
- `alinta` - Alinta office VPN connection
- `tallygroup` - Tally Melbourne office VPN connection

### 3. Plan and Apply

```bash
terraform plan
terraform apply
```

The configuration will automatically use the appropriate settings based on the selected workspace.

## Adding a New Client

1. Copy the template YAML file in the `clients` directory and rename it to match the client's workspace name:

```bash
# Example: For a client with workspace name "new_client"
cp clients/template.yaml clients/new_client.yaml
```

2. Edit the client configuration in the YAML file:

```yaml
---
# New client configuration
name: "aws-tg-new-client-office"
customer_gateway_ip_address: "x.x.x.x"

# Optional overrides - uncomment and modify as needed
# tunnel1_ike_versions:
#   - "ikev2"
# 
# tunnel1_phase1_encryption_algorithms:
#   - "AES256"
#   - "AES256-GCM-16"
#
# bgp_asn: 65001
```

The configuration system will automatically:
- Load the configuration file that matches the current workspace name
- Merge the client-specific values with the common values (client values take precedence)

**Important**: The YAML file name must exactly match the workspace name (e.g., `new_client.yaml` for workspace `new_client`).

This allows you to customize any aspect of the VPN configuration for each client while maintaining a consistent base configuration.

2. Create a new workspace and deploy:

```bash
terraform workspace new new_client
terraform plan
terraform apply
```

## State Migration from Previous Setup

If you're migrating from the previous setup (with hardcoded backend keys), follow these steps:

1. Back up the current state:

```bash
terraform state pull > backup.tfstate
```

2. Create the new workspace:

```bash
terraform workspace new <client_name>
```

3. Import the state:

```bash
terraform state push backup.tfstate
```

4. Verify no changes are required:

```bash
terraform plan
```

## Configuration Structure

- `_backend.tf` - S3 backend configuration with workspace-aware paths
- `_settings.tf` - AWS provider configuration
- `locals.tf` - Configuration logic with common and client-specific settings
- `site-to-site-vpn.tf` - Main module configuration and local variable definitions

## Outputs

- `workspace` - The current Terraform workspace
- `client_name` - The client name for the VPN connection
