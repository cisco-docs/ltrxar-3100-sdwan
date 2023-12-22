# Region List

A Region list contains region-ids and/or ranges of region-ids.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    region_lists:
      - name: RL-GLOBAL
        region_ids:
          - 1
          - 2
        region_id_ranges:
          - from: 10
            to: 20
          - from: 30
            to: 40
      - name: RL-CORE
        region_ids:
          - 0
```
