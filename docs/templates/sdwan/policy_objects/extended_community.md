# Extended Community List

Configure extended BGP community lists.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      extCommunity:
        - name: EXTCOMMUNITY-LEGACY-WAN
          description: "Legacy WAN Extended community list"
          entries:
          - community: soo 1:1;rt 1:1
```
