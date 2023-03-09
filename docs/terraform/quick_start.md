# Quick Start

## Setup

Clone [this](https://wwwin-github.cisco.com/netascode/nac-sdwan-example) repository.

Install [Terraform](https://www.terraform.io/downloads) (> 1.3.0), and the following Python tools:

- [iac-validate](https://github.com/netascode/iac-validate)

```shell
pip install iac-validate
```

Set environment variables pointing to vManage:

```shell
export SDWAN_USERNAME=admin
export SDWAN_PASSWORD=Cisco123
export SDWAN_URL=https://10.1.1.1
```

Encrypted secrets (`$CRYPT_CLUSTER$...`) might have to be updated like documented [here](https://wwwin-github.cisco.com/AS-Customer/sdwanac).

## Initialization

```shell
terraform init
```

This command will download all the required providers and modules from the public Terraform Registry ([https://registry.terraform.io](https://registry.terraform.io)).

## Pre-Change Validation

```shell
iac-validate data/
```

This command performs syntactic and semantic validation of YAML input files located in `data/`.

## Terraform Plan/Apply

```shell
terraform apply
```

This command will apply/deploy the desired configuration.

## Terraform Destroy

```shell
terraform destroy
```

This command will delete all the previously created configuration.
