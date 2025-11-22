# VPN Interface Ethernet Feature Template

Configure an interface name, the status of the interface, static or dynamic IPv4 and v6 addressing, DHCP helper, NAT, VRRP, shaping, QoS, ingress/egress access control list (ACL) for IPv4 and 6, policing, static Address Resolution Protocol (ARP), 802.1x, duplex, MAC address, IP maximum transmission unit (MTU), Transmission Control Protocol maximum segment size (TCP MSS), TLOC extension, and more. In the case of the transport VPN, configure tunnel, transport color, allowed protocols for the interface, encapsulation, preference, weight, and more.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure Ethernet interface as a transport tunnel interface with static IPv4 address configuration, NAT enabled, QoS map attached with shaping_rate as variable. Tunnel's settings: public TLOC color, list of allowed protocols (dhcp,dns,icmp,ntp), restrict enabled, IPsec encapsulation, IPsec preference and weight as variables, Manager connection preference and tunnel group settings as variables.

```yaml
sdwan:
  edge_feature_templates:
    ethernet_interface_templates:
      - name: FT-CEDGE-WAN-TLOC1
        description: CEDGE TLOC1 with static IP Settings, NAT enabled
        interface_description_variable: vpn0_tloc01_if_description
        interface_name_variable: vpn0_tloc01_if_name
        ipv4_address_variable: vpn0_tloc01_if_ipv4_address
        ipv4_nat: true
        ipv4_nat_type: interface
        qos_map: QOS-MAP-1P4Q
        shaping_rate_variable: vpn0_tloc01_shaping_rate
        shutdown_variable: vpn0_tloc01_if_shutdown
        tunnel_interface:
          allow_service_dhcp: true
          allow_service_dns: true
          allow_service_icmp: true
          allow_service_ntp: true
          color_variable: biz-internet
          restrict_variable: true
          ipsec_encapsulation: true
          ipsec_preference_variable: vpn0_tloc01_tunnel_ipsec_preference
          ipsec_weight_variable: vpn0_tloc01_tunnel_weight
          group_variable: vpn0_tloc01_tunnel_group
          hello_interval: 1000
          hello_tolerance: 12
          vmanage_connection_preference_variable: vpn0_tloc01_tunnel_vmanage_connection_preference
```

Example-2: The example below illustrates how to configure Ethernet interface as a Service VPN interface with static IPv4 address configuration and VRRP. VRRP settings: group id, virtual address, priority, timer as variables and OMP tracking enabled

```yaml
sdwan:
  edge_feature_templates:
    ethernet_interface_templates:
      - name: FT-EDGE-VPN10-LAN-IF-VRRP-01
        description: CEDGE, VPN 10, L3 LAN, VRRP
        interface_description_variable: vpn10_lan_if_description
        interface_name_variable: vpn10_lan_if_name
        ipv4_address_variable: vpn10_lan_if_ipv4_address
        shutdown_variable: vpn10_lan_if_shutdown
        ipv4_vrrp_groups:
          - id_variable: vpn10_lan_vrrp_group_id
            address_variable: vpn10_lan_vrrp_group_ip
            priority_variable: vpn10_lan_vrrp_group_priority
            timer_variable: vpn10_lan_vrrp_group_timer
            tloc_preference_change: false
            track_omp: true
```