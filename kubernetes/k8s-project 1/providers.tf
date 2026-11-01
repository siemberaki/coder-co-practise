


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

provider "helm" {
  kubernetes = {
    host = module.eks.cluster_endpoint

    cluster_ca_certificate = base64decode(
      module.eks.cluster_certificate_authority_data
    )

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"

      args = [
        "eks",
        "get-token",
        "--region",
        "us-east-1",
        "--cluster-name",
        module.eks.cluster_name
      ]

      command = "aws"
    }
  }
}
