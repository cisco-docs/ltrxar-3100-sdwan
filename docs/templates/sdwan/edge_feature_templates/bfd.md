# BFD Feature Template

Specify the BFD app-route multiplier and poll interval and specify the hello and BFD multiplier for each transport.

{{ doc_gen }}

### Examples

Example-1: This examples shows how to configure BFD Template: "Feature Template Name", "Feature Template Description", "Device Type"

Basic Configuration depicts "Multiplier" Default value is 6, "Poll Interval in milliseconds", Default is 600,000 and  "Default DSCP value for BFD packets" Default value is 48.

Color Configuration section shows Color based BFD Settings: "Color",  "Hello Interval (milliseconds)" Default 1000, "Multiplier" Default value is 7, "Path MTU Discovery On/Off" Default value is ON, "BFD Default DSCP value for tloc color" Default value is 48

```yaml
sdwan:
  edge_feature_templates:
    bfd_templates:
      - name: FT-CEDGE-BFD-01
        description: BFD base template
        device_types:
          - C8000V
        multiplier: 4
        Poll Interval: 120000
        colors:
          - color: custom1
            default_dscp: 14
            multiplier: 6
            hello_interval: 5000
            Path MTU Discovery: On
          - color_variable: second_internet_tloc
            hello_interval: 5000
```
