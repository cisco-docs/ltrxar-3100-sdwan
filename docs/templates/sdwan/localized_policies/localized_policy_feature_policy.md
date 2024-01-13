# Feature Localized Policy

Configure localized policy.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    feature_policies:
      - name: LOCAL-POLICY-TEMPLATE-01
        description: "Localized Policy v01"
        ipv4_flow_visibility: true
        ipv4_application_visibility: true
        implicit_acl_logging: false
        definitions:
          ipv4_access_control_lists:
            - ACL-TLOCEXT-DSCP
            - ACL-TUNNEL
          qos_maps:
            - QOS-MAP-1P2Q
            - QOS-MAP-1P4Q
          route_policies:
            - ROUTE-MAP-SET-OMPTAG
            - ROUTE-MAP-BLOCK-OSPF
```
