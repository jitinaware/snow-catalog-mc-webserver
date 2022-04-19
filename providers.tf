terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.9.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner       = "Jay Aware"
      Purpose     = "SNOW Demo"
      Terraform   = true
      Environment = "development"
      DoNotDelete = true
    }
  }

}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}