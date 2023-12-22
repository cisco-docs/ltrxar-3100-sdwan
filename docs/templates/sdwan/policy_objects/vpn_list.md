# VPN List

Configure VPN lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    vpn_lists:
      - name: VPN-MGMT
        vpn_ids:
          - 511
        vpn_id_ranges:
          - from: 51
            to: 55
```
