# Edge BGP Feature Template

Configure the AS number, router ID, distance, maximum paths, neighbors, redistribution of protocols into BGP, hold time, and keepalive timers.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    bgp_templates:
      - name: FT-CEDGE-BGP-VPN1
        description: VPN 1 BGP
        device_types:
          - C8000V
        as_number_variable: vpn1_bgp_as_number
        ipv4_address_family:
          default_information_originate: false
          maximum_paths_variable: vpn1_bgp_ipv4_maximum_paths
          redistributes:
            - protocol: omp
              optional: false
            - protocol: ospf
              route_policy: OSPF2BGP
          neighbors:
            - address_variable: vpn1_bgp_ipv4_neighbor1_address
              address_families:
                - family_type: ipv4-unicast
                  maximum_prefixes: 1000
              next_hop_self: false
              password_variable: vpn1_bgp_ipv4_neighbor1_password
              remote_as_variable: vpn1_bgp_ipv4_neighbor1_remote_as
              shutdown_variable: vpn1_bgp_ipv4_neighbor1_shutdown
              optional: true
        shutdown_variable: vpn1_bgp_shutdown
        holdtime: 3
        keepalive: 1
```
