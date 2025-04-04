# VPN List

Configure VPN lists.

{{ doc_gen }}

### Examples
Example-1: This Example shows how to configure a VPN list with a single VPN id.

```yaml
sdwan:
  policy_objects:
    vpn_lists:
      - name: Corporate_VPN
        vpn_ids:
          - 10
```

Example-2: This Example shows how to configure a VPN list using a range of VPNs.
```yaml
sdwan:
  policy_objects:
      - name: Corporate_VPNs
        vpn_id_ranges:
          - from: 10
            to: 12
```

Example-3: This Example shows how to configure a VPN list using one VPN ID and a range of VPNs.

```yaml
sdwan:
  policy_objects:
      - name: Corporate_VPNs
        vpn_ids:
          - 1
        vpn_id_ranges:
          - from: 10
            to: 12
```