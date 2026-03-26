module "sdwan" {
  source  = "netascode/nac-sdwan/sdwan"
  version = "1.3.0"

  yaml_directories = ["data/"]

  write_default_values_file = "defaults.yaml"
}

terraform {
  backend "http" {
    skip_cert_verification = true
  }
}
