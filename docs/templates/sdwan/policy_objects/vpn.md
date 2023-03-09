# VPN List

Configure VPN lists.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      vpn:
        - name: VPN-MGMT
          description: "Mgmt VPNs"
          entries:
            - vpn: "511"
            - vpn: 51-52
```
