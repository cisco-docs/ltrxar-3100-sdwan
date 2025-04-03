# FQDN List

FQDN list specifies one or more FQDN or pattern.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration for the FQDN list matching exact URL 'cisco.com' OR any URL that finishes with '.service-now.com' OR any URL that finishes with '.demo.acme.net'

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