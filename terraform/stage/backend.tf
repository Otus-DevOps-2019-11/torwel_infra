data "terraform_remote_state" "remote_state" {
  backend = "gcs"
  config = {
    bucket = "storage-bucket-torwel-krsk"
    prefix = "terraform/stage"
  }
}
