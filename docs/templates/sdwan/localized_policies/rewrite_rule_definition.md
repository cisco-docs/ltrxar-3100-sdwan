# Rewrite Rule Definition

Configure policy rewrite rules for the QoS mapping.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      rewriteRule:
        - name: REWRITE-RULE-MPLS
          description: "DCSP rewrite for MPLS underlay"
          parameters:
            definition:
              rules:
                - class: CLASS-REALTIME
                  dscp: "46"
                  plp: high
                - class: CLASS-NETCONTROL
                  dscp: "48"
                  plp: high
                - class: CLASS-DEFAULT
                  dscp: "0"
                  plp: low
                - class: CLASS-CRITICALDATA
                  dscp: "26"
                  plp: high
                - class: CLASS-SCAVENGER
                  dscp: "0"
                  plp: low
```
