# Transport BGP Feature

Configure the AS number, router ID, distance, maximum paths, neighbors, redistribution of protocols into BGP, hold time, and keepalive timers.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a transport BGP feature with AS number 65000 that redistributes connected and static routes into BGP and has one neighbor with address and remote AS defined as variables.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        bgp_features:
          name: bgp1
          as_number: 65000
          ipv4_redistributes:
            - protocol: connected
            - protocol: static
          ipv4_neighbors:
            - address_variable: vpn0_bgp_ipv4_neighbor1_address
              remote_as_variable: vpn0_bgp_ipv4_neighbor1_remote_as
```
