# SNMP Feature Template

Configure SNMP parameters, including SNMP device name and location, SNMP version, views, and communities, and trap groups.

{{ doc_gen }}

### Examples

Example-1: Enhanced Network Visibility with SNMP Templates in SD-WAN

A large enterprise with multiple branch offices needs a centralized SNMP monitoring solution for its SD-WAN edge devices. The customer requires secure and scalable SNMP configuration across different router models to enable network monitoring, fault detection, and performance management. The solution must support SNMPv3 with authentication and encryption, multiple SNMP users, and trap servers to send alerts for critical network events. Additionally, the customer wants a template-based approach for consistent configuration across devices while allowing flexibility for customization.

This configuration ensures secure and efficient SNMP monitoring for SD-WAN edge devices, allowing centralized network visibility and real-time alerting using SNMP traps.

```yaml
sdwan:
  edge_feature_templates:
    snmp_templates:
      - name: Enterprise_SNMP_Config
        description: SNMP configuration for branch routers
        device_types:
          - ISR-4331
          - ISR-4351
          - C1111-8P
          - C8300-1N1S-4T2X
        communities:
          - name: $CRYPT_CLUSTER$_public
            authorization_read_only: true
        groups:
          - name: snmpv3_group
            security_level: auth-priv
            view: snmpv3_view
        users:
          - name: snmpadmin
            authentication_protocol: sha
            authentication_password: $CRYPT_CLUSTER$_auth_pass
            privacy_protocol: aes-cfb-128
            privacy_password: $CRYPT_CLUSTER$_priv_pass
            group: snmpv3_group
        trap_target_servers:
          - ip: 192.168.1.100
            community_name: $CRYPT_CLUSTER$_public
            udp_port: 162
            source_interface: GigabitEthernet0/0
        views:
          - name: snmpv3_view
            oids:
              - id: 1.3.6.1.2.1
                exclude: false
```
