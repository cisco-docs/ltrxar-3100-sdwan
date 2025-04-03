# Transport WAN VPN Feature

Add WAN VPN configuration, including DNS servers, NAT, IPv4 or IPv6 static routes and service routes.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a WAN VPN feature under a transport profile. It configures the static host mapping for the "vbond.local" FQDN and maps it to two IP addresses. It also specifies the IPv4 primary and secondary addresses as variables (these will need to be filled when deploying the configuration to a device that uses the configuration group with this profile). It defines a static default route with two next hops configured as variables. Additionally, it enables enhanced ECMP keying and the Traffic Engineering (TE) service.

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
