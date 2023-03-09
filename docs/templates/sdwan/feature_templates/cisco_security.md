# Cisco Security Feature Template

Change the rekey time, anti-replay window, and authentication types for IPsec.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_security:
      - name: FT-CEDGE-SECURITY-01
        description: "Base SD-WAN data-plane security"
        parameters:
          ipsec:
            rekey: 172800
```
