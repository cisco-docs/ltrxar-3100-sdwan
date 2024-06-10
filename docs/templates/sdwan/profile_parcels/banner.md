# Banner Profile Parcel

Configure the login banner or message-of-the-day banner.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        banner:
          name: banner
          description: basic banner
          login: |
            This is line 1 of banner\n
            This is line 2 of banner\n
          motd_variable: motd_banner
```
