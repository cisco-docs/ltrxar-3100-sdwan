# Policy Object Feature Profile

Using an policy object profile, you can configure objects like prefix-lists, color-lists and simmilar to be used in the policies. Note SD-WAN Manager supports only single policy object profile globally.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a policy object feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      name: policy_object
      description: basic policy object profile
```
