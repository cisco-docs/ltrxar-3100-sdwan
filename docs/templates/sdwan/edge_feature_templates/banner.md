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
        login: 'login banner: new\n'
        motd: 'motd banner:\r\nNo message today\n'
      - name: FT-CEDGE-BANNER-02
        description: Base banner template v2
        login: 'login banner: new\ttest\n'
        motd: 'motd banner:\r\nNo message today\n'
      - name: FT-CEDGE-BANNER-03
        description: Base banner template v3
        login: "login banner plain text"
        motd: "motd banner plain text"
      - name: FT-CEDGE-BANNER-04
        description: Base banner template v4
        login_variable: login_banner_variable1
        motd_variable: motd_banner_variable1
```

Note: use single quoted YAML strings when the login or motd banner contains escape sequences like \r , \t, \n etc.