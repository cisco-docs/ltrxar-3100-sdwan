# Overview

*SD-WAN as Code* supports an inventory-driven approach, where a complete SD-WAN configuration (or parts of it) are  modeled in one or more YAML files.

## Structure

One of the key principles of *SD-WAN as Code* is to provide complete separation of data (*variable definition*) from logic (*infrastructure declaration*). This is achieved by separating the *.yaml files which contain the desired SD-WAN state from the Terraform module which maps the definition of the desired state to Terraform resources.

```shell
$ tree -L 2
.
├── data
│   ├── cedge_device_templates.yaml
│   ├── cedge_feature_templates.yaml
│   ├── localized_policies.yaml
│   └── sites.yaml
└── main.tf
```

## SD-WAN Provider

The following Terraform provider is being used together with the *SD-WAN as Code* solution: [link](https://registry.terraform.io/providers/netascode/sdwan/latest)

The provider includes resources to manage various vManage objects, like feature templates, device templates or policy objects. A simple example of how to use a resource can be found below:

```Terraform
resource "sdwan_cisco_banner_feature_template" "example" {
  name         = "Example"
  description  = "My Example"
  device_types = ["vedge-C8000V"]
  login        = "My Login Banner"
  motd         = "My MOTD Banner"
}
```

Every resource is not only capable of pushing a configuration but also reading its state and reconcile configuration drift.

## *Network-as-Code SD-WAN* Module

The *SD-WAN* Terraform module is responsible for mapping the data to the corresponding Terraform resource.

## Pre-Change Validation

Syntax validation ensures that the input data is syntactically correct, which is verified by [Yamale](https://github.com/23andMe/Yamale) and a corresponding schema. The [schema](https://wwwin-github.cisco.com/netascode/nac-sdwan/blob/master/schemas/sdwan.yaml) specifies the expected structure, input value types (String, Enum, IP, etc.) and additional constraints (eg. value ranges, regexes, etc.).

A sample schema can be found below:

```yaml
# SDWAN-as-code YAML schema
sdwan:
  vmanage: include("vmanage", required=False)
  cedge_feature_templates: include("cedge_feature_templates", required=False)
  localized_policies: include("localized_policies", required=False)
  cedge_device_templates: include("cedge_device_templates", required=False)
  sites: include("sites", required=False)
---
# vManage API settings
vmanage:
  vmanage_ip: ip()
  vmanage_user: str()
  vmanage_password: str()
```

Semantic validation is about verifying specific data model related constraints like referential integrity. It can be implemented using a rule based model like commonly done with linting tools. Examples are:

- Check uniqueness of key values (e.g., feature template names)
- Check references/relationships between objects (e.g., device variable values)

To perform syntactic and semantic validation, [iac-validate](https://github.com/netascode/iac-validate) can be used.

```shell
iac-validate ./data/
```
