# Multi-Region Fabric Feature

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
          region_id: 1
          secondary_region_id_variable: mrf_secondary_region_id
          role: edge-router
```
