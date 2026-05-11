# Service Switchport Feature

This feature configures switchport functionality on SD-WAN devices, enabling Layer 2 switching capabilities with support for VLANs, 802.1X authentication, and MAC address management.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service switchport feature with access mode interface and basic settings.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        switchport_features:
          - name: service_switchport_1
            description: Basic access port configuration
            age_out_time: 300
            interfaces:
              - name: GigabitEthernet0/0/1
                mode: access
                access_vlan: 100
                speed: 1000
                duplex: full
```

Example-2: The example below demonstrates how to configure a trunk port with VLAN ranges and 802.1X authentication.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        switchport_features:
          - name: service_switchport_2
            description: Trunk port with authentication
            interfaces:
              - name: GigabitEthernet0/0/2
                mode: trunk
                trunk_native_vlan: 1
                trunk_allowed_vlans:
                  - 10
                  - 20
                  - 30
                  - 500-600
                host_mode: multi-auth
                control_direction: both
                mac_authentication_bypass: true
                guest_vlan: 999
                critical_vlan: 998
                enable_voice: true
                voice_vlan: 300
```

Example-3: The example below demonstrates how to configure static MAC address bindings.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        switchport_features:
          - name: service_switchport_3
            description: Switchport with static MAC addresses
            interfaces:
              - name: GigabitEthernet0/0/3
                mode: access
                access_vlan: 150
            static_mac_addresses:
              - interface_name: GigabitEthernet0/0/3
                mac_address: 0102.0303.0402
                vlan_id: 150
```
