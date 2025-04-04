# System Logging Feature

Configure logging to disk and/or to a remote logging server.

{{ doc_gen }}

### Examples

Example-1: This example is showing a basic logging to two Syslog servers. It is logging informational level and below. It is using in-band management VPN and a loopback interface as a source.
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
              severity: information
              source_interface: Loopback511
              vpn_id: 511
            - hostname_ip: 172.16.0.12
              severity: information
              source_interface: Loopback511
              vpn_id: 511
```
