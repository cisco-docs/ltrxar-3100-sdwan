# Preferred Color Group

Preferred color group defines transport color preferences that can be used in Application-Aware Policy actions.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    preferred_color_groups:
      - name: PREFER_MPLS
        primary_colors:
          - private1
          - private2
          - private3
        primary_path: direct-path
        secondary_colors:
          - custom1
          - custom2
          - custom3
```
