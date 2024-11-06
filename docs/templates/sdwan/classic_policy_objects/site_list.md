# Site List

A Site list contains site-ids and/or ranges of site-ids.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    site_lists:
      - name: SL-EMEA
        site_ids:
          - 1000
          - 2000
        site_id_ranges:
          - from: 10000
            to: 19999
      - name: DC
        site_ids:
          - 100000
```
