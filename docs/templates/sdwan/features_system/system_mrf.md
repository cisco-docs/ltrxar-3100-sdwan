# System Multi-Region Fabric Feature

Configure Multi-Region Fabric parameters.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        mrf:
          name: mrf
          description: basic mrf
          role: edge-router
```
