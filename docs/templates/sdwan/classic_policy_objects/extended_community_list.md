# Extended Community List

Configure extended BGP community lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    extended_community_lists:
      - name: EXTCOMMUNITY-LEGACY-WAN
        extended_communities:
          - soo 1:1
          - rt 1:1
```
