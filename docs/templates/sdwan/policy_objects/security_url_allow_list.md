# Security URL Allow List

Configure Security URL Allow list.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security URL Allow list with urls.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_url_allow_lists:
        - name: security_url_allow_list
          urls:
            - cisco.com
            - www.google.com
```
