# Cisco BFD Feature Template

Specify the BFD app-route multiplier and poll interval and specify the hello and BFD multiplier for each transport.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_bfd:
      - name: FT-CEDGE-BFD-01
        description: BFD base template
        parameters:
          color:
            - color: custom1
            - color: custom2
            - color: private1
            - color: private2
```
