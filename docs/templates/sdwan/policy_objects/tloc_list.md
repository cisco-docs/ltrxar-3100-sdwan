# TLOC List

A TLOC list contains a list of SD-WAN TLOCs, where each TLOC is identified by the color, encapsulation, and system-ip address.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    tloc_lists:
      - name: TLOC-EMEA-HUB
        tlocs:
          - color: custom1
            encapsulation: ipsec
            tloc_ip: 10.0.2.101
            preference: 100
          - color: custom2
            encapsulation: ipsec
            tloc_ip: 10.0.2.101
```
