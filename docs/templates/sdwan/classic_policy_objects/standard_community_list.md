# Standard Community List

A community list is used to create groups of communities to use in a match clause of a route map. A community list can be used to control which routes are accepted, preferred, distributed, or advertised.

{{ doc_gen }}

### Examples

Example-1: This example shows configuration of a Standard community list including a single community.

```yaml
sdwan:
  policy_objects:
    standard_community_lists:
      - name: COMMUNITY_LIST_REGION_1
        standard_communities:
          - 100:100
```

Example-2: This example shows configuration of a Standard community list including two different communities.

```yaml
sdwan:
  policy_objects:
    standard_community_lists:
      - name: COMMUNITY_LIST_REGION_1_2
        standard_communities:
          - 100:100
          - 200:200
```

Example-3: This example shows configuration of a Standard community list including a well-known community.

```yaml
sdwan:
  policy_objects:
    standard_community_lists:
      - name: COMMUNITY_LIST_NO_ADVERTISE
        standard_communities:
          - no-advertise
```

Example-4: This example shows configuration of a Standard community list including a well-known community.

```yaml
sdwan:
  policy_objects:
    standard_community_lists:
      - name: COMMUNITY_LIST_REGIO_1_NO_EXPORT
        standard_communities:
          - 100:200
          - no-export
```

