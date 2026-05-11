# Service LAN VPN Feature

Configure LAN VPN feature.

{{ doc_gen }}

### Examples

Example-1: Basic LAN VPN Configuration

The example below illustrates how to configure a LAN VPN feature within a service profile. It defines the LAN VPN instance, specifying the VPN ID, static IPv4 and IPv6 routes for internal network reachability, OMP route advertisements, DNS server addresses as well as static host mapping. 
```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: BRANCH-LAN-VPN20
        description: Branch LAN VPN 20
        lan_vpns:
          - name: BRANCH-LAN-VPN20
            description: Branch LAN VPN for internal users
            vpn_id: 20
            vpn_name: VPN20-LAN
            ipv4_omp_advertise_routes:
              - protocol: connected
              - protocol: static
              - protocol: ospf
                route_policy: route-policy-omp 
            ipv4_primary_dns_address: 10.2.1.1
            ipv4_secondary_dns_address: 10.2.1.2                           
            ipv4_static_routes:
              - network_address: 10.10.10.0
                subnet_mask: 255.255.255.0
                gateway: nexthop
                next_hops:
                  - address: 10.2.1.1
                    administrative_distance: 1 
            ipv6_static_routes:
              - prefix: 2001:0:0:2::0/64
                gateway: nexthop
                next_hops:
                  - address: 2001:0:0:1::1
                    administrative_distance: 1
            ipv6_omp_advertise_routes:
              - protocol: Connected
              - protocol: Static
            ipv6_primary_dns_address: 2001:0:0:1::1
            ipv6_secondary_dns_address: 2001:0:0:2::2
            host_mappings:
              - hostname: fileserver.example
                ips: 
                  - 10.20.0.10
            route_leaks_from_global:
              - protocol: connected
                redistributions:
                  - protocol: ospf
                    route_policy: import-from-global
```

