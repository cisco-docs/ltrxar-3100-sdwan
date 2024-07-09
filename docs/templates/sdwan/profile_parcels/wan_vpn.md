# WAN VPN Profile Parcel

Add WAN VPN configuration, including DNS servers, NAT, IPv4 or IPv6 static routes and service routes.

{{ doc_gen }}

### Examples

Note that the example below does not contain configuration of other required profile parcels.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport
        description: this is a test transport profile
        wan_vpn:
          name: wan_vpn
          description: VPN 0 configuration
          host_mappings:
            - hostname: vbond.local
              ips:
                - 10.0.0.1
                - 10.0.0.2
          ipv4_primary_dns_address_variable: vpn0_dns_primary
          ipv4_secondary_dns_address_variable: vpn0_dns_secondary
          enhance_ecmp_keying: true
          ipv4_static_routes:
            - network_address: 0.0.0.0
              subnet_mask: 0.0.0.0
              next_hops:
                - address_variable: vpn0_ipv4_default_route_nexthop1_ip
                - address_variable: vpn0_ipv4_default_route_nexthop2_ip
          services:
            - TE
```
