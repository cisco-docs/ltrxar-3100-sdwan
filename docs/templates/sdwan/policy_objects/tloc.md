# TLOC List

A TLOC list contains a list of SD-WAN TLOCs, where each TLOC is identified by the color, encapsulation, and system-ip address.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      tloc:
        - name: TLOC-EMEA-HUB
          description: EMEA HUB TLOCs
          entries:
          - color: custom1
            encap: ipsec
            tloc: 10.0.2.101
          - color: custom2
            encap: ipsec
            tloc: 10.0.2.101
```
