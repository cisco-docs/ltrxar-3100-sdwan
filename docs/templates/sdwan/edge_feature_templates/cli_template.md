# CLI Feature Template

Configure devices using CLI templates.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cli-template:
      - name: FT-CEDGE-CLI-01
        description: "cEdge CLI template"
        parameters:
          config: |
            ! Enable new BGP community format
            ip bgp-community new-format
```
