# Transport WAN VPN GRE Interface Feature

Configure WAN VPN (VPN 0) GRE interface feature.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a gre interface feature under wan_vpn feature within a transport profile. It defines GRE tunnels in the WAN VPN context for SD-WAN, the interface is configured with application_tunnel_type, clear_dont_fragment, interface_name, interface_description, ipv4_address, ipv4_subnet_mask, ipv4_mtu, ipv4_tcp_mss, shutdown, tunnel_source_ipv4_address and tunnel_destination_ipv4_address.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          gre_interfaces:
            - name: wan_interface_gre
              description: WAN GRE Interface
              application_tunnel_type: none
              clear_dont_fragment: false
              interface_name: gre1
              interface_description: gre1 interface
              ipv4_address: 70.1.1.1
              ipv4_subnet_mask: 255.255.255.0
              ipv4_mtu: 1200
              ipv4_tcp_mss: 1100
              shutdown: false
              tunnel_source_ipv4_address: 10.0.0.1
              tunnel_destination_ipv4_address: 10.0.0.10
```
