# Extended Community List

Configure extended BGP community lists.

{{ doc_gen }}

### Examples

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
            - rt 1:1
```
