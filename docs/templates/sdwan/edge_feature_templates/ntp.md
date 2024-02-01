# NTP Feature Template

Configure NTP servers and authentication if required.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    ntp_templates:
      - name: FT-CEDGE-NTP-01
        description: "Base NTP template; no auth key; no ntp master"
        servers:
          - hostname_ip: 172.16.0.11
            prefer: true
            source_interface_variable: ntp_server_source_interface
            vpn_id: 0
          - hostname_ip: time-pnp.cisco.com
            prefer: false
            source_interface: ntp_server_source_interface
            vpn_id: 0
```
