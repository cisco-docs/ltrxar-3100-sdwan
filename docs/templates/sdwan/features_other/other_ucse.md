# Other UCSE Feature

Configure the UCSE feature to connect a UCS-E interface with a UCS-E server.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure UCSE feature with CIMC IP and gateway configured as variable, dedicated access port and single interface in VPN 1.

```yaml
sdwan:
  feature_profiles:
    other_profiles:
      - name: basic_other
        ucse:
          name: ucse
          description: ucse feature
          bay: 1
          slot: 2
          cimc_access_port_dedicated: true
          cimc_ipv4_address_variable: imc_ip_mask
          cimc_default_gateway_variable: imc_gw
          cimc_vlan_id: 100
          cimc_assign_priority: 5
          interfaces:
            - interface_name: ucse1
              vpn_id: 1
              ipv4_address_variable: ucse1_ip_mask
```
