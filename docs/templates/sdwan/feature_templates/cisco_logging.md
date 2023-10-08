# Cisco Logging Feature Template

Configure logging to disk and/or to a remote logging server.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_logging:
      - name: FT-CEDGE-LOGGING-01
        description: "Base Logging template; no TLS"
        parameters:
          server:
          - name: 172.16.0.11
            priority: warn
            source-interface: DEVICE_VARIABLE;logging_server_source_interface
            vpn: 511
          - name: 172.16.0.12
            priority: warn
            source-interface: DEVICE_VARIABLE;logging_server_source_interface
            vpn: 511
```
