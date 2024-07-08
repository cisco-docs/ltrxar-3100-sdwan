# Zones

Zones defines the VPN List or Interface List that can be used in Security Policies.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    zones:
      - name: zone_1_vpn
        vpn_ids:
          - 0
          - 10
          - 500
          - 65530
      - name: zone_2_interface
        interfaces:
          - Ethernet0/1
          - GigabitEthernet1/10
```