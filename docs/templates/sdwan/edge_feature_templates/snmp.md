# SNMP Feature Template

Configure SNMP parameters, including SNMP device name and location, SNMP version, views, and communities, and trap groups.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    snmp_templates:
      - name: FT-CEDGE-SNMPV3-01
        description: "SNMPv3 template"
        contact: DEVICE_VARIABLE;snmp_contact
        groups:
          - name: GROUP_AUTH_PRIV
            security_level: auth-priv
            view: VIEW_ALL
        location_variable: snmp_location
        shutdown_variable: snmp_shutdown
        trap_target_servers:
          - ip: 172.16.0.11
            udp_port: 514
            source_interface_variable: snmp_trap_source_interface
            user: user01
            vpn_id: 511
        users:
          - authentication_protocol: sha
            authentication_password: $CRYPT_CLUSTER$ENUwbbutISa31iAXuryRqQ==$CVy9EkMrtaPjTUFxNPv/QA==
            group: GROUP_AUTH_PRIV
            name: user03
            privacy_protocol: aes-cfb-128
            privacy_password: $CRYPT_CLUSTER$ENUwbbutISa31iAXuryRqQ==$CVy9EkMrtaPjTUFxNPv/QA==
        views:
          - name: VIEW_ALL
            object_identifiers:
              - id: "1.3"
              - id: "1.3.5"
                exclude: true
```
