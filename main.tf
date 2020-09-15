provider "azurerm" {
  version = "=2.20.0"
  features {}
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "google" {
  project = var.gcp_project_id
  region  = "us-east1"
  credentials = file(var.gcp_credentials_path)
}

module "aws" {
  source  = "./aws"
}

module "gcp" {
  source  = "./gcp"
}

# module "gcp" {
#   source  = "./gcp"
# }