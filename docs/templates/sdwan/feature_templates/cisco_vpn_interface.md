# Cisco VPN Interface Feature Template

Configure an interface name, the status of the interface, static or dynamic IPv4 and v6 addressing, DHCP helper, NAT, VRRP, shaping, QoS, ingress/egress access control list (ACL) for IPv4 and 6, policing, static Address Resolution Protocol (ARP), 802.1x, duplex, MAC address, IP maximum transmission unit (MTU), Transmission Control Protocol maximum segment size (TCP MSS), TLOC extension, and more. In the case of the transport VPN, configure tunnel, transport color, allowed protocols for the interface, encapsulation, preference, weight, and more.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_vpn_interface:
      - name: FT-CEDGE-WAN-TLOC1
        description: "CEDGE TLOC1 with dynamic IP Settings, NAT enabled"
        parameters:
          description: DEVICE_VARIABLE;vpn0_tloc01_if_description
          if-name: DEVICE_VARIABLE;vpn0_tloc01_if_name
          ip:
            dhcp-client: "true"
            dhcp-distance: 1
          nat:
            nat-choice: interface
          shaping-rate: DEVICE_VARIABLE;vpn0_tloc01_shaping_rate
          shutdown: DEVICE_VARIABLE;vpn0_tloc01_if_shutdown
          tunnel-interface:
            allow-service:
              dhcp: "true"
              dns: "true"
              icmp: "true"
              ntp: "true"
            clear-dont-fragment: "false"
            color:
              restrict: DEVICE_VARIABLE;vpn0_tloc01_tunnel_restrict
              value: DEVICE_VARIABLE;vpn0_tloc01_tunnel_color
            encapsulation:
              - encap: ipsec
                preference: DEVICE_VARIABLE;vpn0_tloc01_tunnel_ipsec_preference
                weight: DEVICE_VARIABLE;vpn0_tloc01_tunnel_weight
            group: DEVICE_VARIABLE;vpn0_tloc01_tunnel_group
            hello-interval: 1000
            hello-tolerance: 12
            vmanage-connection-preference: DEVICE_VARIABLE;vpn0_tloc01_tunnel_vmanage_connection_preference
```
