# Expanded Community List

Configure expanded BGP community lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      name: policy_object
      description: basic policy object profile
      expanded_community_lists:
        - name: community_legacy_wan
          expanded_communities:
            - 65001:101
            - 65002:102
            - 65003:103
```
