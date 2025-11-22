# Preferred Color Group

Preferred color group defines transport color preferences that can be used in Application-Aware Policy actions.

{{ doc_gen }}

### Examples

Example-1: This Example shows a preferred color group configuration using a single color and the primary path is set to direct-path.

```yaml
sdwan:
  policy_objects:
    preferred_color_groups:
      - name: PREFER_MPLS
        primary_colors:
          - mpls
        primary_path: direct-path
```
Example-2: This Example shows a preferred color group configuration using a single color and the primary path is set to all-paths.

```yaml
sdwan:
  policy_objects:
    preferred_color_groups:
      - name: PREFER_ALL_PATHS_MPLS
        primary_colors:
          - mpls
        primary_path: all-paths
```

Example-3: This Example shows a preferred color group configuration using as primary colors two different private colors and the primary path is set to all-paths.

```yaml
sdwan:
  policy_objects:
    preferred_color_groups:
      - name: PREFER_ALL_PATHS_PRIVATE
        primary_colors:
          - mpls
          - private1
        primary_path: all-paths
```

Example-4: This Example shows a preferred color group configuration using MPLS as primary color, biz-internet as secondary color and public-internet as tertiary color. Each color group is using a diferent path: direct path, multi-hop path and all-paths respectively.

```yaml
sdwan:
  policy_objects:
    preferred_color_groups:
      - name: PREFER_MPLS_OVER_INTERNET
        primary_colors:
          - mpls
        secondary_colors:
          - biz-internet
        tertiary_colors:
          - public-internet
        primary_path: direct-path
        secondary_path: multi-hop-path
        tertiary_path: all-paths
```
Example-5: This Example shows a preferred color group configuration where private colors are preferred and direct-path is selected as primary path. Secondary color selected are public colors with no path seleccted.

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
