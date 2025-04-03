# CLI Feature Template

Configure devices using CLI Add-On Templates. This feature template used to attach specific CLI configurations to a device.

{{ doc_gen }}

### Examples

Example-1: This example shows how with CLI Add-On to add BFD configuration to be used by BGP protocol for rapid failure detection: first defining BFD template with interval and multiplier parameters, which then is attached to the BGP neighbor, and also enable new BGP community format.

```yaml
sdwan:
  cedge_feature_templates:
    cli-template:
      - name: FT-CEDGE-CLI-01
        description: "cEdge CLI template"
        parameters:
          config: |
          ip bgp-community new-format
          bfd-template single-hop test
           interval min-tx 400 min-rx 400 multiplier 5
          interface GigabitEthernet3
            bfd template test
          router bgp {{vpn10_bgp_as_number_cli}}
          address-family ipv4 vrf 10
           neighbor {{vpn10_bgp_ipv4_neighbor1_address_cli}} soft-reconfiguration inbound
           neighbor {{vpn10_bgp_ipv4_neighbor1_address_cli}} fall-over bfd
```
