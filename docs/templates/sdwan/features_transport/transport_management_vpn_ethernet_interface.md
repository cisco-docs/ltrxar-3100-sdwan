# Transport Management VPN Ethernet Interface Feature

Configure out of band management VPN (VPN 512) Ethernet interface and its' settings.

{{ doc_gen }}

### Examples

The example below demonstrates how to configure the management interface feature under management_vpn feature within a transport profile with static ipv4 address settings.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        management_vpn:
          name: management_vpn
          ethernet_interfaces:
            - name: management_interface
              interface_name: GigabitEthernet8
              ipv4_address_variable: mgmt_intf_ip
              ipv4_subnet_mask_variable: mgmt_intf_mask
```

The example below demonstrates how to configure the management interface feature under management_vpn feature within a transport profile with dynamic ipv4 and ipv6 address settings.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        management_vpn:
          name: management_vpn
          ethernet_interfaces:
            - name: management_interface
              interface_name: GigabitEthernet8
              ipv4_configuration_type: dynamic
              ipv6_configuration_type: dynamic
```
