# BFD Feature Template

Specify the BFD app-route multiplier and poll interval and specify the hello and BFD multiplier for each transport.

{{ doc_gen }}

### Examples

Example-1: This examples shows how to configure BFD Template: "Feature Template Name", "Feature Template Description", "Device Type"

Basic Configuration depicts "Multiplier" Default value is 6, "Poll Interval in milliseconds", Default is 600,000 and  "Default DSCP value for BFD packets" Default value is 48.

Color Configuration section shows Color based BFD Settings: "Color",  "Hello Interval (milliseconds)" Default 1000, "Multiplier" Default value is 7, "Path MTU Discovery On/Off" Default value is ON/true, "BFD Default DSCP value for tloc color" Default value is 48

```yaml
sdwan:
  edge_feature_templates:
    bfd_templates:
      - name: FT-EDGE-BFD-02
        description: BFD base template
        poll_interval: 30000
        multiplier: 6
        default_dscp: 48
        colors:
          - color: biz-internet
            path_mtu_discovery: true
            default_dscp: 48
            hello_interval: 30010
            multiplier: 5
          - color: mpls 
```
