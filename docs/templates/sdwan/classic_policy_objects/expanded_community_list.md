# Expanded Community List

Configure expanded BGP community lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    expanded_community_lists:
      - name: COMMUNITY-LEGACY-WAN
        expanded_communities:
          - 65001:101
          - 65002:102
          - 65003:103
```
