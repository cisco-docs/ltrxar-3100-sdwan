# Rewrite Rule Definition

Configure policy rewrite rules for the QoS mapping.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      rewrite_rules:
        - name: REWRITE-RULE-MPLS
          description: "DCSP rewrite for MPLS underlay"
          rules:
            - class_map: CLASS-REALTIME
              dscp: 46
              priority: high
            - class: CLASS-NETCONTROL
              dscp: 48
              priority: high
            - class: CLASS-DEFAULT
              dscp: 0
              layer2_cos: 0
              priority: low
```
