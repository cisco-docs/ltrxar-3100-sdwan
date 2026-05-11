# Service OSPFv3 IPv6 Feature

This feature enables OSPFv3 IPv6 routing protocol within service VPN segments, allowing the device to exchange routing information with service-side devices.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service OSPFv3 IPv6 feature with Router ID as variable, Area 1 with interface (interface name is variable and cost is 10), Range (cost is 1, prefix is 3002::/96, and no_advertise is false) and route redistribution of connected routes into OSPFv3 IPv6.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        ospfv3_ipv6_features:
          - name: service_ospfv3_ipv6
            description: service ospfv3 ipv6 feature
            router_id_variable: service_ospf_router_id
            areas:
              - number: 1
                type: stub
                interfaces:
                  - name_variable: service_ospfv3_ipv6_interface
                    cost: 10
                ranges:
                  - cost: 1
                    prefix: 3002::/96
                    no_advertise: false
            redistributes:
              - protocol: connected
```
