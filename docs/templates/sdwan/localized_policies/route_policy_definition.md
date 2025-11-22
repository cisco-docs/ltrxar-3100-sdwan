# Route Policy Definition

Configure route policies.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      route_policies:
        - name: ROUTE-MAP-SET-OMPTAG
          description: "Set OMP tag based on community list"
          default_action: accept
          sequences:
            - id: 10
              ip_type: ipv4
              base_action: accept
              match_criterias:
                standard_community_lists:
                  - COMMUNITY-LIST-REGION1
                  - COMMUNITY-LIST-REGION2
                standard_community_lists_criteria: or
              actions:
                omp_tag: 12345
```
