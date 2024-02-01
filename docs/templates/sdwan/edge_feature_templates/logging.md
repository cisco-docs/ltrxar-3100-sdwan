# Logging Feature Template

Configure logging to disk and/or to a remote logging server.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    logging_templates:
      - name: FT-CEDGE-LOGGING-01
        description: "Base Logging template; no TLS"
        ipv4_servers:
          - hostname_ip: 172.16.0.11
            logging_level: warn
            source_interface_variable: logging_server_source_interface
            vpn_id: 511
          - hostname_ip: 172.16.0.12
            logging_level: warn
            source_interface_variable: logging_server_source_interface
            vpn_id: 511
```
