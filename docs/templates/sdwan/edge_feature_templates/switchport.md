# Switchport Feature Template

Use the Switch Port template to configure bridging for Cisco Catalyst SD-WAN.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    switchport_templates:
      - name: FT-CEDGE-SWITCHPORT-V01
        description: "Switchport Template"
        slot: 0
        sub_slot: 1
        module_type: 8
        interfaces:
          - name_variable: switchport_access_interface_name
            mode: access
            access_vlan: 10
            optional: true
            shutdown: false
            dot1x:
              enable: true
              guest_vlan: 20
          - name_variable: switchport_trunk_interface_name
            mode: trunk
            trunk_native_vlan: 100
            trunk_allowed_vlans:
              - 100
              - 105
              - 110
            optional: true
            shutdown: false
```
