# Cisco SNMP Feature Template

Configure SNMP parameters, including SNMP device name and location, SNMP version, views, and communities, and trap groups.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_snmp:
      - name: FT-CEDGE-SNMPV3-01
        description: "SNMPv3 template"
        parameters:
          contact: DEVICE_VARIABLE;snmp_contact
          group:
            - name: GROUP_AUTH_PRIV
              security-level: auth-priv
              view: VIEW_ALL
          location: DEVICE_VARIABLE;snmp_location
          shutdown: DEVICE_VARIABLE;snmp_shutdown
          trap:
            target:
              - community-name: $CRYPT_CLUSTER$MVeouqBXy9Od6dAYMJ6eTQ==$z0Pl/8UAxXkt1lXOnayv8A==
                ip: 172.16.0.11
                port: 514
                source-interface: DEVICE_VARIABLE;snmp_trap_source_interface
                user: user01
                vpn-id: 511
          user:
            - auth: sha
              auth-password: $CRYPT_CLUSTER$ENUwbbutISa31iAXuryRqQ==$CVy9EkMrtaPjTUFxNPv/QA==
              group: GROUP_AUTH_PRIV
              name: user03
              priv: aes-cfb-128
              priv-password: $CRYPT_CLUSTER$ENUwbbutISa31iAXuryRqQ==$CVy9EkMrtaPjTUFxNPv/QA==
          view:
            - name: VIEW_ALL
              oid:
                - exclude: "false"
                  id: "1.3"
```
