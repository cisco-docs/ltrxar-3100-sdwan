# SNMP Feature

Configure SNMP parameters, including SNMP device name and location, SNMP version, views, and communities, and trap groups.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        snmp:
          name: snmpv2
          description: basic snmpv2
          contact_person_variable: snmp_contact
          communities:
            - authorization: read-write
              name: test123
              user_label: test
              view: view_all
          location_variable: snmp_location
          shutdown_variable: snmp_shutdown
          trap_target_servers:
            - ip: 172.16.0.11
              port: 514
              source_interface_variable: snmp_trap_source_interface
              user_label: test
              vpn_id: 511
          views:
            - name: view_all
              oids:
                - id: "1.3"
                - id: "1.3.5"
                  exclude: true
      - name: system2
        description: this is test system profile
        snmp:
          name: snmpv3
          description: basic snmpv3
          contact_person_variable: snmp_contact
          groups:
            - name: group_auth_priv
              security_level: auth-priv
              view: view_all
          location_variable: snmp_location
          shutdown_variable: snmp_shutdown
          trap_target_servers:
            - ip: 172.16.0.11
              port: 514
              source_interface_variable: snmp_trap_source_interface
              user: user01
              vpn_id: 511
          users:
            - authentication_protocol: sha
              authentication_password: $CRYPT_CLUSTER$ENUwbbutISa31iAXuryRqQ==$CVy9EkMrtaPjTUFxNPv/QA==
              group: group_auth_priv
              name: user01
              privacy_protocol: aes-cfb-128
              privacy_password: $CRYPT_CLUSTER$ENUwbbutISa31iAXuryRqQ==$CVy9EkMrtaPjTUFxNPv/QA==
          views:
            - name: view_all
              oids:
                - id: "1.3"
                - id: "1.3.5"
                  exclude: true
```
