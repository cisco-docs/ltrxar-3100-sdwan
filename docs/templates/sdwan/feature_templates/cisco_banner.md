# Cisco Banner Feature Template

Configure the login banner or message-of-the-day banner.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_banner:
      - name: FT-CEDGE-BANNER-01
        description: Base banner template; support carrier returns
        parameters:
          login: "login banner: new\n"
          motd: "motd banner:\r\nNo message today\n"
```
