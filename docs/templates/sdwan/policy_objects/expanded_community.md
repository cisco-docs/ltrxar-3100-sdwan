# Expanded Community List

Configure expanded BGP community lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      expandedCommunity:
        - name: COMMUNITY-LEGACY-WAN
          description: "Legacy WAN community list"
          entries:
          - community: 65001:101
          - community: 65002:102
          - community: 65003:103
```
