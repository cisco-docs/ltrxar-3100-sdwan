# Application List

A `application list` groups one or more applications or application familes into a named application list which can be used in centralized policies.

{{ doc_gen }}

### Examples

Example-1: Create a Application List
This example demonstrates how to create a Application List named Social-Media that groups facebook, twitter, youtube, instagram and linkedin.

```yaml
sdwan:
  policy_objects:
    application_lists:
      - name: Social-Media
        applications:
          - facebook
          - twitter
          - youtube
          - instagram
          - linkedin
```
