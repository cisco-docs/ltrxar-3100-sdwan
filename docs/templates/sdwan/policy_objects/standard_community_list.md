# Standard Community List

A community list is used to create groups of communities to use in a match clause of a route policy. A community list can be used to control which routes are accepted, preferred, distributed, or advertised.

{{ doc_gen }}

### Examples

The example below demonstrates how to configure the standard community list matching communities no-export, 1000:1000 and/or 1000:1002 (the end/or criteria can be selected when assigning community list inside route policy).

```yaml
sdwan:
  policy_objects:
    standard_community_lists:
      - name: standard_community_list1
        standard_communities:
          - no-export
          - 1000:1000
          - 1000:1002
```
