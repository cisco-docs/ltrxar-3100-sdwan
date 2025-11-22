# Preferred Color Group

A Preferred Color Group is a group of multiple colors in primary, secondary and tertiary colors with respective preferences.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Preferred Color Group to have default and mpls as primary colors, custom1 and custom2 as secondary colors, followed by biz-internet and custom3 as tertiary colors.
The primary, secondary and tertiary path preference takes value from all-paths, direct-path and multi-hop-path respectively.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      preferred_color_groups:
        - name: preferred_color_group1
          description: Preferred Color Group 1
          primary_colors:
            - default
            - mpls
          primary_path_preference: all-paths
          secondary_colors:
            - custom1
            - custom2
          secondary_path_preference: direct-path
          tertiary_colors:
            - biz-internet
            - custom3
          tertiary_path_preference: multi-hop-path
```
