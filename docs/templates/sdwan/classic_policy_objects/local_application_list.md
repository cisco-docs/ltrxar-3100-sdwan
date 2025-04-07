# Local Application List

A `Local Application list` specifies one or more applications or applications families for use in `Security Policies`.
Application names should be provided in the format accepted by the API.

{{ doc_gen }}

### Examples

Example-1: Create a Application List
This example demonstrates how to create a Application List named Social-Media that groups facebook, twitter, youtube, instagram and linkedin for use in `Security Policies`.

```yaml
sdwan:
  policy_objects:
    local_application_lists:
      - name: Social-Media
        applications:
          - facebook
          - twitter
          - youtube
          - instagram
          - linkedin
```
