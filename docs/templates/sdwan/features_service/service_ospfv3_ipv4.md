# Service OSPFv3 IPv4 Feature

This feature enables OSPFv3 IPv4 routing protocol within service VPN segments, allowing the device to exchange routing information with service-side devices.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service OSPFv3 IPv4 feature with Router ID as variable, Area 0 with interface as variable and cost set to 10. The network to be advertised is 192.168.1.0/24 and route redistribution of connected routes into OSPFv3 IPv4.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: LAN1
        ospfv3_ipv4_features:
          - name: service_ospfv3_ipv4
            description: service ospfv3 ipv4 feature
            router_id_variable: service_ospfv3_ipv4_router_id
            areas:
              - number: 0
                interfaces:
                  - name_variable: service_ospfv3_ipv4_interface
                    cost: 10
                ranges:
                  - network_address: 192.168.1.0
                    subnet_mask: 255.255.255.0
            redistributes:
              - protocol: connected
```