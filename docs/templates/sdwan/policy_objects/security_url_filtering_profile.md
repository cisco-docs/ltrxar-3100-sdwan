# Security URL Filtering Profile

Configure Security URL Filtering Profile.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security URL Filtering Profile with block_page_action, block_page_content_body, enable_alerts, web_categories, web_categories_action, and web_reputation.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_url_filtering_profiles:
        - name: url_filtering_profile_basic
          block_page_action: text
          block_page_content_body: Please contact your administrator.
          enable_alerts: false
          web_categories:
            - music
          web_categories_action: block
          web_reputation: high-risk
```
