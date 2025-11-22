# Feature Localized Policy

Localized policy set is a combination of QoS policy , Access Control Lists and Route Policy.Localized policies are used for sites in SDWAN environment where there is a requirement for configurations that has to be applied local to the site as opposed to centralized policy.

{{ doc_gen }}

### Examples

Example-1 : In the below example , LOCAL-POLICY-BGP-01 is created and mostly would be applicable to sites which run BGP as protocol on service side.
As defined below , it references the already defined qos_maps ( QOS-MAP-1P4Q ) , route_policies ( RM-SITE-BGP-OUT-ACTIVE , RM-SITE-BGP-OUT-STANDBY ,
RM-SITE-BGP-TO-OMP-ACTIVE , RM-SITE-BGP-TO-OMP-STANDBY ) and ipv4_device_access_policies ( ACL-DEVICEACCESSPOLICY-01 ).

In addition to the references , application_visibility , flow_visibility and cache_entries have been defined .

```yaml
sdwan:
  localized_policies:
    feature_policies:
      - name: LOCAL-POLICY-BGP-01
        description: Localized Policy | BGP Site v01
        ipv4_application_visibility: true
        ipv6_application_visibility: true
        ipv4_flow_visibility: true
        ipv6_flow_visibility: false
        implicit_acl_logging: false
        ipv4_visibility_cache_entries: 2000
        ipv6_visibility_cache_entries: 4000
        log_frequency: 1024
        definitions:
          qos_maps:
            - QOS-MAP-1P4Q
          route_policies:
            - RM-SITE-BGP-OUT-ACTIVE
            - RM-SITE-BGP-OUT-STANDBY
            - RM-SITE-BGP-TO-OMP-ACTIVE
            - RM-SITE-BGP-TO-OMP-STANDBY
          ipv4_device_access_policies:
            - ACL-DEVICEACCESSPOLICY-01
```

Example-2 : In the below example , LOCAL-POLICY-OSPF-01 is created and mostly would be applicable to sites which run OSPF as protocol on service side.
As defined below , it references the already defined qos_maps ( QOS-MAP-1P4Q ) , route_policies ( RM-SITE-OMP-TO-OSPF-ACTIVE , RM-SITE-OMP-TO-OSPF-STANDBY ) and ipv4_device_access_policies ( ACL-DEVICEACCESSPOLICY-01 ).

In addition to the references , application_visibility , flow_visibility and cache_entries have been defined .

```yaml
sdwan:
  localized_policies:
    feature_policies:
      - name: LOCAL-POLICY-OSPF-01
        description: Localized Policy v01
        ipv4_application_visibility: true
        ipv6_application_visibility: false
        ipv4_flow_visibility: true
        ipv6_flow_visibility: false
        implicit_acl_logging: false
        ipv4_visibility_cache_entries: 1000
        ipv6_visibility_cache_entries: 1000
        log_frequency: 1024
        definitions:
          qos_maps:
            - QOS-MAP-1P4Q
          route_policies:
            - RM-SITE-OMP-TO-OSPF-ACTIVE
            - RM-SITE-OMP-TO-OSPF-STANDBY
          ipv4_device_access_policies:
            - ACL-DEVICEACCESSPOLICY-01
```

Example-3 : In the below example , LOCAL-POLICY-LAN-01 is created and mostly would be applicable to sites which don't intent to run any protocol on service side.
As defined below , it references the already defined qos_maps ( QOS-MAP-1P4Q ) , route_policies ( ROUTE-MAP-PL ) and ipv4_device_access_policies ( ACL-DEVICEACCESSPOLICY-01 ).

In addition to the references , application_visibility , flow_visibility and cache_entries have been defined .

```yaml
sdwan:
  localized_policies:
    feature_policies:
      - name: LOCAL-POLICY-LAN-01
        description: Localized Policy v01
        ipv4_application_visibility: true
        ipv6_application_visibility: false
        ipv4_flow_visibility: true
        ipv6_flow_visibility: false
        implicit_acl_logging: false
        ipv4_visibility_cache_entries: 1000
        ipv6_visibility_cache_entries: 1000
        log_frequency: 1024
        definitions:
          qos_maps:
            - QOS-MAP-1P4Q
          route_policies:
            - ROUTE-MAP-PL
          ipv4_device_access_policies:
            - ACL-DEVICEACCESSPOLICY-01
```
