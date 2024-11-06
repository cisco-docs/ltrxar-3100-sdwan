# FQDN List

FQDN list specifies one or more FQDN or pattern.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    fqdn_lists:
      - name: fqdn_list_1
        fqdns:
          - cisco.com
          - '*.service-now.com'
          - '*.demo.acme.net'
```