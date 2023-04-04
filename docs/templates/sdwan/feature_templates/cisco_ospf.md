# Cisco OSPF Feature Template

Configure the OSPF Routing parameters for a IOS-XE WAN Edge. This feature tempalte is referenced under a VPN feature template in the cEdge Device Template.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_ospf:
      - name: FT-CEDGE-OSPF-01
        description: "OSPF base template"
        parameters:
          ospf:
            area:
              - a-num: 0
                interface:
                  - authentication:
                      message-digest:
                        md5: md5string
                        message-digest-key: 1
                      type: message-digest
                    name: DEVICE_VARIABLE;ospf_area0_if_name
                    passive-interface: 'false'
            default-information:
              originate: 'false'
            redistribute:
              - protocol: omp
                route-policy: DEVICE_VARIABLE;ospf_redistribute_omp_route_policy
            router-id: DEVICE_VARIABLE;ospf_router_id
```
