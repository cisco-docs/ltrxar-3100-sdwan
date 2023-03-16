# Site List

A Site list contains site-ids and/or ranges of site-ids.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      site:
        - name: SL-EMEA
          description: EMEA site ranes
          entries:
          - siteId: 1000-1999
          - siteId: 10000-19999
```
