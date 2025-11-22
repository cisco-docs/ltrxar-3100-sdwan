# System NTP Feature

Configure NTP servers and authentication if required.

{{ doc_gen }}

### Examples

Example-1: Example shows a basic NTP configuration where edge is using  two NTP servers in VPN0 without authentication.

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
            - hostname_ip: time-pnp.cisco.com
              prefer: true
              source_interface: Loopback0
              vpn_id: 0
            - hostname_ip: time.google.com
              prefer: false
              source_interface: Loopback0
              vpn_id: 0
```

Example-2: Example where edges are connecting to enterprise NTP servers inside service VPN 10 and are using authentication keys. First server is defined with static values while second one uses variables. Variables would be used for example if using same template and customer has regional NTP servers.

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system2
        description: "System profile for NTP example"
        ntp:
          name: ntp
          description: "NTP template in service VPN and with authentication"
          authentication_keys:
            - id: 1
              value: Cisco123
          servers:
            - hostname_ip: 172.16.0.11
              prefer: true
              source_interface: Loopback0
              vpn_id: 10
              authentication_key_id: 1
            - hostname_ip_variable: system_ntp_server2_ip
              prefer_variable: system_ntp_server2_prefer
              source_interface_variable: ntp_server2_source_interface
              vpn_id_variable: system_ntp_server2_vpnid
              authentication_key_id_variable: system_ntp_server2_keyid
```
