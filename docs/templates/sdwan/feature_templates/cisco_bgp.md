# Cisco BGP Feature Template

Configure the AS number, router ID, distance, maximum paths, neighbors, redistribution of protocols into BGP, hold time, and keepalive timers.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_bgp:
      - name: FT-CEDGE-BGP-VPN1
        description: VPN 1 BGP
        parameters:
          bgp:
            address-family:
              - default-information:
                  originate: "false"
                family-type: ipv4-unicast
                maximum-paths:
                  paths: DEVICE_VARIABLE;vpn1_bgp_ipv4_maximum_paths
                redistribute:
                  - protocol: omp
                    optional: false
            as-num: DEVICE_VARIABLE;vpn1_bgp_as_number
            neighbor:
              - address: DEVICE_VARIABLE;vpn1_bgp_ipv4_neighbor1_address
                address-family:
                  - family-type: ipv4-unicast
                    maximum-prefixes:
                      prefix-num: 1000
                next-hop-self: "false"
                password: DEVICE_VARIABLE;vpn1_bgp_ipv4_neighbor1_password
                remote-as: DEVICE_VARIABLE;vpn1_bgp_ipv4_neighbor1_remote_as
                shutdown: DEVICE_VARIABLE;vpn1_bgp_ipv4_neighbor1_shutdown
                optional: true
            shutdown: DEVICE_VARIABLE;vpn1_bgp_shutdown
            timers:
              holdtime: 3
              keepalive: 1
```
