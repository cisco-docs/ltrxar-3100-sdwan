# IGMP Feature Template

Specify the cEdge IGMP interface name and join groups for each interfaces.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure cEdge IGMP feature with interface name and join groups for each interfaces.

```yaml
sdwan:
  edge_feature_templates:
    igmp_templates:
      - name: FT-CEDGE-IGMP-01
        description: Basic cEdge IGMP Feature Template
        interfaces:
          - name: GigabitEthernet1
            join_groups:
              - group_address: 224.1.1.1
                source: 10.10.10.10
```
