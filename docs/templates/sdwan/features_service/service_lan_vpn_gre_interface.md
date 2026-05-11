# Service LAN VPN GRE Interface Feature

Configure LAN VPN GRE interface feature.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a service GRE interface feature within a LAN VPN in a service profile. It defines GRE tunnels in the LAN VPN context for SD-WAN, enabling traffic routing between different endpoints through an encapsulated GRE tunnel.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        lan_vpns:
          - name: service_lan_vpn1
            description: lan_vpn1_test
            vpn_id: 1
            vpn_name: VPN1
            gre_interfaces:
              - name: lan_interface_gre
                description: LAN GRE Interface
                application_tunnel_type: none
                clear_dont_fragment: false
                interface_name: gre1
                interface_description: gre1 interface
                ipv4_address: 70.1.1.1
                ipv4_subnet_mask: 255.255.255.0
                ipv4_mtu: 1500
                ipv4_tcp_mss: 1460
                shutdown: false
                tunnel_source_ipv4_address: 10.0.0.1
                tunnel_destination_ipv4_address: 10.0.0.10
```