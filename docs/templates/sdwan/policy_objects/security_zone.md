# Security Zone

Configure Security Zone.

### Notes

- Each Security Zone must have either `vpns` **or** `interfaces` configured, but not both.
- VPN names must reference existing LAN VPNs defined in `service_profiles.lan_vpns`.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security Zone with VPNs.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_zones:
        - name: security_zone1
          vpns:
            - service_lan_vpn1
            - service_lan_vpn2
```

Example-2: This example demonstrates how to configure a Security Zone with Interfaces.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_zones:
        - name: security_zone2
          interfaces:
            - GigabitEthernet1
            - GigabitEthernet2
```
