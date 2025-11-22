# Application List

An `application list` groups one or more applications or application familes into a named application list which can be used in centralized policies.
Application names should be provided in the format accepted by the API.

{{ doc_gen }}

### Examples

Example-1: Create an Application List
This example demonstrates how to create an Application List named Social-Media that groups facebook, twitter, youtube, instagram and linkedin.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      application_lists:
        - name: Social-Media
          applications:
            - facebook
            - twitter
            - youtube
            - instagram
            - linkedin
```

Example-2: Create an Application Family List
This example demonstrates how to create an Application Family List named APPF-CRITICALDATA that groups application-service, database, erp, microsoft-office, middleware and network-management.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      application_lists:
        - name: APPF-CRITICALDATA
          application_families:
            - application-service
            - database
            - erp
            - microsoft-office
            - middleware
            - network-management
```
