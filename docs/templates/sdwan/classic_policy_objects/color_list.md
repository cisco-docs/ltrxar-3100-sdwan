# Color List

A color list contains a list of one or more SD-WAN tloc colors.

{{ doc_gen }}

### Examples

Example-1: Configuring a Color List for policies
This example demonstrates how to configure color lists. The example configuration includes the following:

* Color List CL-Public: Contains the colors public-internet, red, and green.
* Color List CL-INTERNET: Contains the color biz-internet.
* Color List CL-MPLS: Contains the color mpls.

Below is the YAML configuration for defining these color lists:

```yaml
sdwan:
  policy_objects:
    color_lists:
      - name: CL-Public
        colors:
          - public-internet
          - red
          - green
      - name: CL-INTERNET
        colors:
          - biz-internet
      - name: CL-MPLS
        colors:
          - mpls
```
