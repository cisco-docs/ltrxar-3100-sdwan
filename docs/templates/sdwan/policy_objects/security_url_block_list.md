# Security URL Block List

Configure Security URL Block list.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates a security URL block list containing blocked website URLs with wildcard pattern support.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_url_block_lists:
        - name: security_url_block_list
          urls:
            - badsite.com
            - www.malicious.com
```
