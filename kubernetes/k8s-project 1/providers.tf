


terraform {
  backend "s3" {

    bucket = "eks-tfstate-siema"

    key = "eks-lab"

    region = "us-east-1"

    encrypt = true


  }

  required_version = ">= 1.0.0"




  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }

  }
}

provider "aws" {
  region = "us-east-1"
}