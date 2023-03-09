# Site

This includes site and device specific configuration including device variables.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  sites:
    - id: 2101
      routers:
      - chassis_id: C8K-CC678D1C-8EDF-3966-4F51-ABFAB64F5ABE
        model: C8000V
        device_template: DT-C8000V-TEST
        device_variables:
          site_id: 2101
          system_ip: 10.0.2.101
          system_hostname: SITE2101-C8KV-01
          logging_server_source_interface: Loopback511
          ntp_server_source_interface: Loopback511
          global_cdp_enable: true
          global_lldp_enable: false
          global_ip_domain_lookup_enable: true
          snmp_shutdown: false
          snmp_trap_source_interface: Loopback511
          snmp_contact: contact@acme.com
          snmp_location: Location 2101
          system_location: Site2101
          system_description: Site 2101 C8KV01
          timezone: UTC
          system_latitude: 38.1
          system_longitude: -1.9
          ondemand_tunnel_enable: false
          ondemand_tunnel_idle_timeout: 10
          vpn0_layer4_ecmp_enable: true
          vpn0_tloc01_if_name: GigabitEthernet1
          vpn0_tloc01_if_description: INET-1
          vpn0_tloc01_if_shutdown: false
          vpn0_tloc01_shaping_rate: 1000000
```
