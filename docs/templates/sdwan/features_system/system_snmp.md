# System SNMP Feature

Configure SNMP parameters, including SNMP device name and location, SNMP version, views, and communities, and trap groups.

{{ doc_gen }}

### Examples

Example-1: This example shows configuration when customer is still using SNMPv2 with communities. Edges send traps to two SNMP servers inside a service VPN from source interface Loopback10.

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: First system template
        snmp_templates:
          - name: FT-EDGE-SNMPV2-01
            description: SNMPv2 template
            contact_variable: snmp_contact
            location_variable: snmp_location
            shutdown_variable: snmp_shutdown
            trap_target_servers:
              - ip: 172.16.0.11
                udp_port: 514
                community_name: $CRYPT_CLUSTER$MVeouqBXy9Od6dAYMJ6eTQ==$z0Pl/8UAxXkt1lXOnayv8A==
                source_interface: Loopback10
                vpn_id: 10
              - ip: 172.16.0.12
                udp_port: 514
                community_name: $CRYPT_CLUSTER$MVeouqBXy9Od6dAYMJ6eTQ==$z0Pl/8UAxXkt1lXOnayv8A==
                source_interface: Loopback10
                vpn_id: 10
            communities:
              - name: $CRYPT_CLUSTER$QxiZDYbM/8ElLYQCgdvUOA==$7ojrXlNnk/0jZ+lnhVJlLQ==
                authorization_read_only: true
                view: VIEW_ALL
            views:
              - name: VIEW_ALL
                oids:
                  - id: "1.3"
                    exclude: false
```

Example-2: This example uses SNMPv3 with most secure option (authentication and privacy). It creates a SNMP group that is then used for SNMP user. SNMP traps are send to two SNMP servers using previously created SNMP user from source interface Loopback10..

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: First system template
        snmp_templates:
          - name: FT-EDGE-SNMPV3-01
            description: SNMPv3 template
            contact_variable: snmp_contact
            groups:
              - name: GROUP_AUTH_PRIV
                security_level: auth-priv
                view: VIEW_ALL
            location_variable: snmp_location
            shutdown_variable: snmp_shutdown
            trap_target_servers:
              - ip: 172.16.0.11
                udp_port: 514
                community_name: $CRYPT_CLUSTER$MVeouqBXy9Od6dAYMJ6eTQ==$z0Pl/8UAxXkt1lXOnayv8A==
                source_interface: Loopback10
                user: user01
                vpn_id: 10
              - ip: 172.16.0.12
                udp_port: 514
                community_name: $CRYPT_CLUSTER$MVeouqBXy9Od6dAYMJ6eTQ==$z0Pl/8UAxXkt1lXOnayv8A==
                source_interface: Loopback10
                user: user01
                vpn_id: 10
            users:
              - name: user01
                group: GROUP_AUTH_PRIV
                authentication_protocol: sha
                authentication_password: $CRYPT_CLUSTER$GU+PR6WV3va2QY07wG6Z6w==$INccS/tPm4BdiwzuP6lUJw==
                privacy_protocol: aes-256-cfb-128
                privacy_password: $CRYPT_CLUSTER$GU+PR6WV3va2QY07wG6Z6w==$INccS/tPm4BdiwzuP6lUJw==
            communities:
              - name: $CRYPT_CLUSTER$QxiZDYbM/8ElLYQCgdvUOA==$7ojrXlNnk/0jZ+lnhVJlLQ==
                authorization_read_only: true
                view: VIEW_ALL
            views:
              - name: VIEW_ALL
                oids:
                  - id: "1.3"
                    exclude: false
              - name: VIEW_ALL2
                oids:
                  - id: "1.3"
                    exclude: false
```
