# Transport WAN VPN Ethernet Interface Feature

Configure WAN VPN (VPN 0) Ethernet interface and its' settings.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a ethernet interface feature under wan_vpn feature within a transport profile with static ipv4 address settings and shutdown set to false. The interface is also configured to be an Internet TLOC and has tunnel interface option enabled with biz-internet color and preference 200.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          ethernet_interfaces:
            - name: inet_tloc
              interface_name: GigabitEthernet1
              ipv4_address_type: static
              ipv4_address_variable: vpn0_inet_ip
              ipv4_subnet_mask_variable: vpn0_inet_mask
              shutdown: false
              tunnel_interface:
                color: biz-internet
                ipsec_preference: 200
```

Example-2: The example below demonstrates how to configure a ethernet interface feature under wan_vpn feature within a transport profile with dynamic ipv4 address settings and shutdown set to false.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          ethernet_interfaces:
            - name: inet_tloc
              interface_name: GigabitEthernet1
              ipv4_address_type: dynamic
              shutdown: false
```

Example-3: The example below demonstrates how to configure a ethernet interface feature under wan_vpn feature within a transport profile with variable ipv4 and ipv6 address settings (note this is supported starting 20.18.1).

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          ethernet_interfaces:
            - name: inet_tloc
              interface_name: GigabitEthernet1
              ipv4_address_type_variable: vpn0_inet_address_type
              ipv4_address_variable: vpn0_inet_ip
              ipv4_subnet_mask_variable: vpn0_inet_mask
              ipv4_dhcp_distance_variable: vpn0_inet_dhcp_distance
              ipv6_address_type_variable: vpn0_inet_v6_address_type
              ipv6_address_variable: vpn0_inet_v6_ip
              shutdown: false
```
