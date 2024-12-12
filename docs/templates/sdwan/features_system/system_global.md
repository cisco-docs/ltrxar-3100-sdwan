# System Global Feature

Configure global settings like SSH version, services, etc.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        global:
          name: global
          description: basic global
          cdp_variable: global_cdp_enable
          domain_lookup_variable: global_ip_domain_lookup_enable
          lldp: true
          http_server: false
```
