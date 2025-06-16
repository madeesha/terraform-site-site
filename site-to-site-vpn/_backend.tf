terraform {
  backend "s3" {
    bucket  = "tallyplussharedspt-terraform-backend"
    region  = "ap-southeast-2"
    encrypt = true
    key     = "site-to-site-vpn/terraform.tfstate"
    # The key will be dynamically set to include the workspace name when using workspaces:
    # actual path: site-to-site-vpn/{workspace}/terraform.tfstate
  }
}
