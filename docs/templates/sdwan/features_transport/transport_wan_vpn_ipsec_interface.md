# Transport WAN VPN IPsec Interface Feature

Configure IPsec interface under the WAN VPN (VPN 0)

{{ doc_gen }}

### Examples

Example-1: This example demonstrates two methods for configuring IPsec interfaces under the wan_vpn feature within a transport profile using IPv4 tunnel mode. IPSEC-1 is configured with an explicit tunnel source IPv4 address, while IPSEC-2 references a tunnel source interface.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          ipsec_interfaces:
            - name: IPSEC-1
              description: IPSEC Interface 1
              interface_name: ipsec1
              ipv4_address: 3.3.3.1
              ipv4_subnet_mask: 255.255.255.252
              ike_preshared_key: mysecret
              shutdown: false
              tunnel_destination_ipv4_address: 2.2.2.2
              tunnel_source_ipv4_address: 1.1.1.1
            - name: IPSEC-2
              description: IPSEC Interface 2
              interface_name: ipsec2
              ike_preshared_key: mysecret
              shutdown: false
              tunnel_destination_ipv4_address: 3.3.3.3
              tunnel_mode: ipv4
              tunnel_source_interface: GigabitEthernet2
```

Example-2: This example demonstrates IPsec interface configuration using IPv6 tunnel modes. IPSEC-3 is configured with pure IPv6 tunnel mode, while IPSEC-4 uses IPv4-v6overlay mode to transport IPv6 traffic over an IPv4 tunnel.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          ipsec_interfaces:
            - name: IPSEC-3
              description: IPSEC Interface 3
              interface_name: ipsec3
              ipv6_address: 2001:db8:1::1/128
              ike_preshared_key: mysecret3
              shutdown: false
              tunnel_destination_ipv6_address: 2001:db8:3::1
              tunnel_mode: ipv6
              tunnel_source_ipv6_address: 2001:db8:2::1
            - name: IPSEC-4
              description: IPSEC Interface 4
              interface_name: ipsec4
              ipv6_address: 2001:db8:4::2/128
              ike_preshared_key: mysecret4
              shutdown: false
              tunnel_destination_ipv4_address: 7.7.7.7
              tunnel_mode: ipv4-v6overlay
              tunnel_source_interface: GigabitEthernet1
```
