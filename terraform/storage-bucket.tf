provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "storage-bucket" {
  source        = "SweetOps/storage-bucket/google"
  version       = "0.3.0"
  name          = "storage-bucket-torwel-krsk"
  location      = "europe-west3"
  storage_class = "Standard"
}

output storage-bucket_url {
  value = module.storage-bucket.url
}

