# Community List

A community list is used to create groups of communities to use in a match clause of a route map. A community list can be used to control which routes are accepted, preferred, distributed, or advertised.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      community:
        - name: COMMUNITY-REGION1
          description: "Region01 community"
          entries:
          - community: 1000:1000
```
