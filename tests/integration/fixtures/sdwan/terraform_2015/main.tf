module "sdwan" {
  source = "git::https://github.com/netascode/terraform-sdwan-nac-sdwan.git?ref=main"

  yaml_directories          = ["../standard", "../standard_2015"]
  write_default_values_file = "defaults.yaml"
}

