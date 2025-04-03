# Extended Community List

Configure extended BGP community lists.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an extended community list matching the site of origin (SOO) community "1:1" and route target (RT) community "1:2".

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      name: policy_object
      description: basic policy object profile
      extended_community_lists:
        - name: ext_community_list
          extended_communities:
            - soo 1:1
            - rt 1:2
```
