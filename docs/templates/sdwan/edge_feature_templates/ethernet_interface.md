# VPN Interface Ethernet Feature Template

Configure an interface name, the status of the interface, static or dynamic IPv4 and v6 addressing, DHCP helper, NAT, VRRP, shaping, QoS, ingress/egress access control list (ACL) for IPv4 and 6, policing, static Address Resolution Protocol (ARP), 802.1x, duplex, MAC address, IP maximum transmission unit (MTU), Transmission Control Protocol maximum segment size (TCP MSS), TLOC extension, and more. In the case of the transport VPN, configure tunnel, transport color, allowed protocols for the interface, encapsulation, preference, weight, and more.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    ethernet_interface_templates:
      - name: FT-CEDGE-WAN-TLOC1
        description: "CEDGE TLOC1 with dynamic IP Settings, NAT enabled"
        interface_description_variable: vpn0_tloc01_if_description
        interface_name_variable: vpn0_tloc01_if_name
        ipv4_address_dhcp: true
        dhcp_distance: 1
        ipv4_nat: true
        ipv4_nat_type: interface
        shaping_rate_variable: vpn0_tloc01_shaping_rate
        shutdown_variable: vpn0_tloc01_if_shutdown
        tunnel_interface:
          allow_service_dhcp: true
          allow_service_dns: true
          allow_service_icmp: true
          allow_service_ntp: true
          clear_dont_fragment: false
          color_variable: vpn0_tloc01_tunnel_color
          restrict: true
          ipsec_encapsulation: true
          ipsec_preference_variable: vpn0_tloc01_tunnel_ipsec_preference
          ipsec_weight_variable: vpn0_tloc01_tunnel_weight
          group_variable: vpn0_tloc01_tunnel_group
          hello_interval: 1000
          hello_tolerance: 12
          vmanage_connection_preference_variable: vpn0_tloc01_tunnel_vmanage_connection_preference
```
