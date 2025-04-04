# Banner Feature Template

Configure the login banner or message-of-the-day banner.
The purpose of a "Message of the Day" (MOTD) banner is to display a temporary message to all users connecting to a device before they authenticate, often used for legal notices, security warnings, or system status updates

The purpose of a Login banners is to display a message to users attempting to log in, often used for security warnings or legal notices
* Name and description fields are mandatory, both fields are string type.
* Device_type is used to limit the devices this template can be applied to. Field type is enum.
* login and motd fields contains the message and must be enclosed by single quotes.

{{ doc_gen }}


### Examples
Examples-1: Use single quoted YAML strings when the login or motd banner contains escape sequences like \r , \t, \n etc.

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



Examples-2: Use ASCII Hex to add line feed and carriage return. ASCII Hex \x0A Line feed, ASCII Hex \x0D Carriage return.

```yaml
sdwan:
  edge_feature_templates:
    banner_templates:
      - name: Customer_Banner
        description: Customer Banner
        device_types:
          - C8000V
          - ISR-4331
        login: 'Login**********************************************************************\\x0d\\x0aLogin next line'
        motd: 'MOTD***************************************************************\\x0d\\x0aMOTD next line'  
```

