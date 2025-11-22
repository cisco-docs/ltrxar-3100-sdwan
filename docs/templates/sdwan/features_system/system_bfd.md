# System BFD Feature

Specify the BFD app-route multiplier and poll interval and specify the hello and BFD multiplier for each transport.

{{ doc_gen }}

### Examples
Example-1: This example shows how to configure BFD feature with multiplier, poll interval and two colors—one with a default DSCP value and the other with a hello interval.

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
