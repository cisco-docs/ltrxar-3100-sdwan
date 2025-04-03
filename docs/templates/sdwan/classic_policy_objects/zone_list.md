# Zone List

Zones defines the VPN List or Interface List that can be used in Security Policies.

{{ doc_gen }}

### Examples

Example-1: This example shows the zone list configuration including a single VPN, in this case only VPN 1.

```yaml
sdwan:
  policy_objects:
    zones:
      - name: Zone_VPN1
        vpn_ids:
          - 1
```

Example-2: This example shows the zone list configuration including two VPNs, in this case includes VPN 1 and VPN 2

```yaml
sdwan:
  policy_objects:
    zones:
      - name: Zone_VPN1_2
        vpn_ids:
          - 1
          - 2
```

Example-3: This example shows the zone list configuration including one interface, in this case includes interface GigabitEthernet0.


```yaml
sdwan:
  policy_objects:
    zones:
      - name: Zone_INT_Gi0
        interfaces:
          - GigabitEthernet0
```

Example-4: This example shows the zone list configuration including two interfaces, in this case includes interfaces GigabitEthernet0 and GigabitEthernet1.

```yaml
sdwan:
  policy_objects:
    zones:
      - name: Zone_INT_Gi0_Gi1
        interfaces:
          - GigabitEthernet0
          - GigabitEthernet1
```

Example-5: This example shows two zone lists configuration including several VPNs and few interfaces, in this case includes interfaces GigabitEthernet0 and GigabitEthernet1.

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
