# BFD Feature Template

Specify the BFD app-route multiplier and poll interval and specify the hello and BFD multiplier for each transport.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    bfd_templates:
      - name: FT-CEDGE-BFD-01
        description: BFD base template
        device_types:
          - C8000V
        multiplier: 4
        colors:
          - color: custom1
            default_dscp: 14
          - color_variable: second_internet_tloc
            hello_interval: 5000
```
