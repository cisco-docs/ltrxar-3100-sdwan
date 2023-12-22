# Standard Community List

A community list is used to create groups of communities to use in a match clause of a route map. A community list can be used to control which routes are accepted, preferred, distributed, or advertised.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    standard_community_lists:
      - name: COMMUNITY-REGION1
        standard_communities:
          - 1000:1000
          - 1000:1002
```
