# Cisco NTP Feature Template

Configure NTP servers and authentication if required.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_ntp:
      - name: FT-CEDGE-NTP-01
        description: "Base NTP template; no auth key; no ntp master"
        parameters:
          server:
          - name: 172.16.0.11
            prefer: 'true'
            source-interface: DEVICE_VARIABLE;ntp_server_source_interface
            vpn: 0
          - name: time-pnp.cisco.com
            prefer: 'false'
            source-interface: DEVICE_VARIABLE;ntp_server_source_interface
            vpn: 0
```
