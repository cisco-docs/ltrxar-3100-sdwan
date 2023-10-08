# cEdge Global Feature Template

Configure global settings like SSH version, services, etc.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cedge_global:
      - name: FT-CEDGE-GLOBAL-01
        description: Base cEdge Global Settings
        parameters:
          services-global:
            services-ip:
              cdp: DEVICE_VARIABLE;global_cdp_enable
              domain-lookup: DEVICE_VARIABLE;global_ip_domain_lookup_enable
              lldp: DEVICE_VARIABLE;global_lldp_enable
```
