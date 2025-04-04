# TLOC List

A TLOC list contains a list of SD-WAN TLOCs, where each TLOC is identified by the color, encapsulation, and system-ip address.

{{ doc_gen }}

### Examples

Example-1: This Example shows how to configure a TLOC List without configuring any precedence.

```yaml
sdwan:
  policy_objects:
    tloc_lists:
      - name: DC_MPLS_No_preference
        tlocs:
          - color: mpls
            encapsulation: ipsec
            tloc_ip: 10.0.0.1
```

Example-2: This Example shows how to configure a TLOC List with preference configured.

```yaml

    tloc_lists:
      - name: DC_MPLS_with_Preference
        tlocs:
          - color: mpls
            encapsulation: ipsec
            tloc_ip: 10.0.0.1
            preference: 100
```

Example-3: This Example shows how to configure a TLOC List including an entry with preference and the second without preference.

```yaml

    tloc_lists:
      - name: DC_MPLS
        tlocs:
          - color: mpls
            encapsulation: ipsec
            tloc_ip: 10.0.0.1
            preference: 100
          - color: mpls
            encapsulation: ipsec
            tloc_ip: 10.0.0.2
```