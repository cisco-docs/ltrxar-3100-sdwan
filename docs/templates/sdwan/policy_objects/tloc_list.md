# TLOC List

A TLOC list contains a list of SD-WAN TLOCs, where each TLOC is identified by the color, encapsulation, and system-ip address.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a TLOC list containing two TLOCs. Each TLOC needs to have TLOC IP (system-ip), color and encapsulation defined. The TLOC preference is optional.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      tloc_lists:
        - name: emea_hub_tlocs
          tlocs:
            - color: custom1
              encapsulation: ipsec
              tloc_ip: 10.0.2.101
              preference: 100
            - color: custom2
              encapsulation: ipsec
              tloc_ip: 10.0.2.101
```
