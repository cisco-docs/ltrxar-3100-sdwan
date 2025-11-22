# CLI Config Feature

Configure additional CLI commands on the device.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure the config feature under the CLI feature profile. The CLI configuration block lists IOS-XE commands to be applied. The line starting with `!` is used as a comment.

```yaml
sdwan:
  feature_profiles:
    cli_profiles:
      - name: cli
        description: basic cli profile
        config:
          name: cli-config
          cli_configuration: |
            ! Enable new BGP community format
            ip bgp-community new-format
```

Example-2: This example demonstrates how to configure the config feature under the CLI feature profile. The CLI configuration block lists IOS-XE commands to be applied. The line starting with `!` is used as a comment. The parameter enclosed between `{{` and `}}` is a variable name. This variable must be provided when deploying a configuration group with this profile to a device.

```yaml
sdwan:
  feature_profiles:
    cli_profiles:
      - name: cli
        description: basic cli profile
        config:
          name: cli-config
          cli_configuration: |
            ! This template is using variables
            router bgp {{bgp_as_number}}
              address-family ipv4 unicast vrf 10
              neighbor {{bgp_neighbor_ip}} local-as {{bgp_neighbor_local_as}}
            !
```
