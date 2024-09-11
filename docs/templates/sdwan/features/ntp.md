# NTP Feature

Configure NTP servers and authentication if required.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        ntp:
          name: ntp
          description: "Base NTP template; no auth key; no ntp master"
          servers:
            - hostname_ip: 172.16.0.11
              prefer: true
              source_interface_variable: ntp_server_source_interface
              vpn_id: 0
            - hostname_ip: time-pnp.cisco.com
              prefer: false
              source_interface: GigabitEthernet0/0/0
              vpn_id: 0
```
