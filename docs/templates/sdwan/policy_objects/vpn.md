# VPN List

Configure VPN lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      vpn:
        - name: VPN-MGMT
          description: "Mgmt VPNs"
          entries:
            - vpn: "511"
            - vpn: 51-52
```
