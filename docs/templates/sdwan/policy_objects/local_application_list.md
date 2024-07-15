# Local Application List

Local Application list specifies one or more NBAR applications or applications families for use in Security Policies.
Application names should be provided in the format accepted by the API.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    local_application_lists:
      - name: office_apps
        applications:
          - ftps-data
          - concur
          - ms-teams-audio
          - ms-teams-media
          - ms-teams-video
      - name: scavenger_apps
        application_families:
          - mail
          - thin-client
      - name: critical_apps
        applications:
          - ms-teams-audio
        application_families:
          - mail
```
