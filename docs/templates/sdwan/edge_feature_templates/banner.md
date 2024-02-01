# Banner Feature Template

Configure the login banner or message-of-the-day banner.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    banner_templates:
      - name: FT-CEDGE-BANNER-01
        description: Base banner template; support carrier returns
        device_types:
          - C8000V
        login: "login banner: new\n"
        message_of_the_day: "motd banner:\r\nNo message today\n"
```
