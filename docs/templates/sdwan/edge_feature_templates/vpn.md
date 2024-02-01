# VPN Feature Template

Change the ECMP hash, add DNS servers, advertise protocols (BGP, static, connected, OSPF external) from the VPN into OMP, and add IPv4 or v6 static routes, service routes, and GRE routes.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    vpn_templates:
      - name: FT-CEDGE-VPN0-01
        description: "EDGE VPN0 with static IP settings"
        ipv4_primary_dns_server_variable: vpn0_dns_primary
        ipv4_secondary_dns_server_variable: vpn0_dns_secondary
        enhance_ecmp_keying: true
        ipv4_static_routes:
          - prefix: 0.0.0.0/0
            next_hops:
              - address_variable: vpn0_ipv4_default_route_nexthop1_ip
              - address_variable: vpn0_ipv4_default_route_nexthop2_ip
        vpn_name: VPN0
        vpn_id: 0
      - name: FT-CEDGE-VPN1-01
        description: "EDGE VPN1 with DIA"
        ipv4_primary_dns_server: 1.1.1.1
        ipv4_secondary_dns_server: 1.0.0.1
        ipv4_static_routes:
          - prefix: 0.0.0.0/0
            next_hop_dia: true
        vpn_name: VPN1
        vpn_id: 1
        services:
          - service_type: TE
```
