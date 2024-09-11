# BFD Feature

Specify the BFD app-route multiplier and poll interval and specify the hello and BFD multiplier for each transport.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        bfd:
          name: bfd
          description: basic bfd
          multiplier: 5
          poll_interval: 12000
          colors:
            - color: custom1
              default_dscp: 14
            - color_variable: second_internet_tloc
              hello_interval: 5000
```
