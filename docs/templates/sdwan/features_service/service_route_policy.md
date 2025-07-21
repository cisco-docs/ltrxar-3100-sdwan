# Service Route Policy Definition

Configure route policies that can be assigned to routing protocols or when advertising routing protocols to OMP.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a service route policy feature that accepts and assigns metric 200 to all prefixes that have OSPF tag 10. All other prefixes are accepted with the default action.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        route_policies:
          - name: route_policy_set_metric
            description: "Set metric for OSPF routes"
            default_action: accept
            sequences:
              - id: 1
                base_action: accept
                match_entries:
                  ospf_tag: 10
                actions:
                  metric: 200
```
