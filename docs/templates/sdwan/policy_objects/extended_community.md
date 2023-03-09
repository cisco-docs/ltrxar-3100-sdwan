# Extended Community List

Configure extended BGP community lists.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      extCommunity:
        - name: EXTCOMMUNITY-LEGACY-WAN
          description: "Legacy WAN community list"
          entries:
          - community: soo 1:1;rt 1:1
```
