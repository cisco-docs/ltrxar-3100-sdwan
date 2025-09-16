# Service OSPF Feature

This feature enables OSPF routing protocol within service VPN segments, allowing the device to exchange routing information with service-side devices.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service OSPF feature with router ID as variable, area 0 with single interface (interface name is variable and cost is 10) and route redistribution of connected routes into OSPF.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        ospf_features:
          - name: service_ospf_1
            router_id_variable: service_ospf_router_id
            areas:
              - number: 0
                interfaces:
                  - name_variable: service_ospf_interface
                    cost: 10
            redistributes:
              - protocol: connected
```
