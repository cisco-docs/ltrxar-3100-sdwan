# Transport OSPF Feature

This feature enables OSPF routing protocol within transport VPN segments, allowing the device to exchange routing information with transport-side devices for WAN connectivity.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a transport OSPF feature with router ID as variable, area 0 with single interface (interface name is variable and cost is 10) and route redistribution of connected routes into OSPF.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        ospf_features:
          - name: transport_ospf_1
            router_id_variable: transport_ospf_router_id
            areas:
              - number: 0
                interfaces:
                  - name_variable: transport_ospf_interface
                    cost: 10
            redistributes:
              - protocol: connected
```