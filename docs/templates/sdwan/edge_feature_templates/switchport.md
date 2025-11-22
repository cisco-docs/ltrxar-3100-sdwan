# Switchport Feature Template

Use the Switch Port template to configure bridging for Cisco Catalyst SD-WAN.

{{ doc_gen }}

### Examples

Example-1: The example below shows the configuration of the switchport on the switch module of 
the router. The switchport configuration is on per port basis so each physical port can either 
be in Access or Trunk mode. The example shows the configuration of one access port. This example 
also shows voice VLAN configuration. 

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
          - name: GigabitEthernet0/1/1 
            mode: access
            access_vlan: 10
            voice_vlan: 20
            optional: true
            shutdown: false
```


Example-2: The example below shows the configuration of the switchport on the switch module of 
the router. The switchport configuration is on per port basis so each physical port can either 
be in Access or Trunk mode. The example shows the configuration of one Trunk port with specific 
set of allowed VLANs. The example also shows the configuration of the native VLAN. 

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
          - name: GigabitEthernet0/1/2
            mode: trunk
            trunk_native_vlan: 100
            trunk_allowed_vlans:
              - 100
              - 105
              - 110
            optional: true
            shutdown: false
```