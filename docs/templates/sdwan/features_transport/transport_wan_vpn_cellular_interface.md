# Transport WAN VPN Cellular Interface Feature

Configure WAN VPN (VPN 0) Cellular interface feature.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a cellular interface feature under wan_vpn feature within a transport profile. It defines Cellular interface in the WAN VPN context for SD-WAN, the interface is configured with adaptive_qos, shaping_rate, enable_ipv6, interface_name, interface_description, tunnel_interface(color), ipv4_nat and shutdown.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: wan_vpn
          cellular_interfaces:
            - name: wan_interface_cellular2
              description: Transport Wan VPN Interface Cellular Basic Example
              adaptive_qos: false
              enable_ipv6: false
              interface_name: Cellular2
              interface_description: Basic WAN Cellular Interface
              shaping_rate: 500000
              tunnel_interface:
                color: 3g
              ipv4_nat: false
              shutdown: true
```
