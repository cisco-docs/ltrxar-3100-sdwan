# Expanded Community List

Configure expanded BGP community lists.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      expandedCommunity:
        - name: COMMUNITY-LEGACY-WAN
          description: "Legacy WAN community list"
          entries:
          - community: 65148:926
          - community: 65149:926
          - community: '65146:10'
```
