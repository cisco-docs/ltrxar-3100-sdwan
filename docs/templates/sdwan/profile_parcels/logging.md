# Logging Profile Parcel

Configure logging to disk and/or to a remote logging server.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        logging:
          name: logging
          description: "Base Logging template; no TLS"
          ipv4_servers:
            - hostname_ip: 172.16.0.11
              severity: warn
              source_interface_variable: logging_server_source_interface
              vpn_id_variable: logging_vpn_id
            - hostname_ip: 172.16.0.12
              severity: warn
              source_interface: Loopback0
              vpn_id: 511
```
