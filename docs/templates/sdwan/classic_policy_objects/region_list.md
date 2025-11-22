# Region List

A `Region list` is a group of one or more regional overlays in the context of Multi-Region Fabric (MRF), range from (1 to 64).
These `Region list` are used in centralized policies as match conditions.
Note: Multi-Region Fabric should be enabled to use region lists.

{{ doc_gen }}

### Examples

Example-1: Create a Region List
This example shows how to create a Region List named MRF-East and MRF-West. MRF-East has a region Id of 1.

```yaml
sdwan:
  policy_objects:
    region_lists:
      - name: MRF-East
        region_ids:
          - 1
```

Example-2: Create a Region List with Range
This example shows how to create a Region List MRF-West which has a region range of 3 to 5.

```yaml
sdwan:
  policy_objects:
    region_lists:
      - name: MRF-West
        region_id_ranges:
          - from: 3
            to: 5
```
