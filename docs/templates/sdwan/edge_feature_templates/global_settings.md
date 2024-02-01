# Global Settings Feature Template

Configure global settings like SSH version, services, etc.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    global_settings_templates:
      - name: FT-CEDGE-GLOBAL-01
        description: Base cEdge Global Settings
        device_types:
          - C8000V
        cdp_variable: global_cdp_enable
        domain_lookup_variable: global_ip_domain_lookup_enable
        lldp: true
        http_server: false
```
