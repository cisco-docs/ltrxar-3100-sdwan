# Feature Policy

Configure policy settings.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    policies:
      feature:
        - name: LOCAL-POLICY-TEMPLATE-01
          description: "Localized Policy v01"
          parameters:
            assembly:
              - definitionName: QOS-MAP-1P4Q
                type: qosMap
            settings:
              appVisibility: true
              appVisibilityIPv6: false
              flowVisibility: true
              flowVisibilityIPv6: false
              implicitAclLogging: false
              ipV6VisibilityCacheEntries: 1000
              ipVisibilityCacheEntries: 1000
              logFrequency: 1024
```
