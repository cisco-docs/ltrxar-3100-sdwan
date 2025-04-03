# Edge BGP Feature Template

Configure the AS number, router ID, distance, maximum paths, neighbors, redistribution of protocols into BGP, hold time, and keepalive timers.

{{ doc_gen }}

### Examples

Example-1: The following example demonstrates how to configure a BGP router with an ASN, specifically targeting the IPv4 unicast address family within a VRF. You can add multiple neighbors under the "neighbors" section. The configuration also includes advertising the network IP prefix and redistributing OMP routes into BGP. A route map policy can be applied for detailed route management. Additionally, the BGP timers are set to a keepalive interval of 1 second and a hold time of 3 seconds, facilitating swift detection of neighbor issues and ensuring network stability.

```yaml
sdwan:
  edge_feature_templates:
    bgp_templates:
      - name: FT-EDGE-VPN13-BGP-01
        description: VPN 13 BGP
        ipv4_address_family:
          default_information_originate: false
          maximum_paths_variable: vpn13_bgp_ipv4_maximum_paths
          redistributes:
            - protocol: omp
              optional: false
              route_policy_variable: vpn13_bgp_ipv4_rm_omp_to_bgp
          neighbors:
            - address_variable: vpn13_bgp_ipv4_neighbor1_address
              address_families:
                - family_type: ipv4-unicast
                  maximum_prefixes: 1000
              next_hop_self: false
              password_variable: vpn13_bgp_ipv4_neighbor1_password
              remote_as_variable: vpn13_bgp_ipv4_neighbor1_remote_as
              shutdown_variable: vpn13_bgp_ipv4_neighbor1_shutdown
              optional: true
          networks:
            - prefix_variable: vpn13_bgp_ipv4_network1_prefix
              optional: true
        as_number_variable: vpn13_bgp_as_number
        shutdown_variable: vpn13_bgp_shutdown
        holdtime: 3
        keepalive: 1
```
