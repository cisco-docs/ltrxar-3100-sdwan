# Color List

Color list specifies one or more SD-WAN TLOC colors.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      color:
        - name: COLOR-INTERNET
          description: Internet colors
          entries:
            - color: custom1
            - color: custom2
```
