data "terraform_remote_state" "backend" {
  backend = "remote"

  config = {
    organization = "jaware-hashicorp"
    workspaces = {
      name = "demo-snow-tf-aws-azure-backend"
    }
  }
}

