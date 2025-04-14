# Banner Feature Template

Configure the login banner or message-of-the-day banner.
The purpose of a "Message of the Day" (MOTD) banner is to display a temporary message to all users connecting to a device before they authenticate, often used for legal notices, security warnings, or system status updates

The purpose of a Login banners is to display a message to users attempting to log in, often used for security warnings or legal notices
* Name and description fields are mandatory, both fields are string type.
* Device_type is used to limit the devices this template can be applied to. Field type is enum.
* login and motd fields contains the message.

{{ doc_gen }}


### Examples

```yaml
sdwan:
  edge_feature_templates:
    banner_templates:
      - name: FT-CEDGE-BANNER-01
        description: Banner template with Carriage return, Line Feed
        device_types:
          - C8000V
        login: "login banner: new\n"
        motd: "motd banner:\r\nNo message today\n"
      - name: FT-CEDGE-BANNER-02
        description: Banner template with Carriage return, Line Feed and horizontal tab
        login: "login banner: new\ttest\n"
        motd: "motd banner:\r\nNo message today\n"
      - name: FT-CEDGE-BANNER-03
        description: Banner template text only single line
        login: "login banner plain text"
        motd: "motd banner plain text"
      - name: FT-CEDGE-BANNER-04
        description: Banner template using variable references
        login_variable: login_banner_variable1
        motd_variable: motd_banner_variable1
      - name: FT-CEDGE-BANNER-05
        description: Typical Multiline banner using Carriage return, Line Feed
        login: "*************************************************************\n*************************************************************\n**\n** UNAUTHORIZED USE PROHIBITED\n** UNAUTHORIZED ACCESS PROHIBITED\n **\n** Log out immediately\n** XXXXXXXXXX\n **\n*************************************************************\n*************************************************************"
      - name: FT-CEDGE-BANNER-06
        description: 'Multiline banner template example'
        login: |
          ***********************************************************
          ***********************************************************
          ** UNAUTHORIZED USE PROHIBITED
          ** UNAUTHORIZED ACCESS PROHIBITED
          **
          ** MANAGED BY:
          ** XXXXXXXXXX
          **
          ***********************************************************
          ***********************************************************
```



Examples-2: Use ASCII Hex to add line feed and carriage return. ASCII Hex \x0A Line feed, ASCII Hex \x0D Carriage return, ASCII Hex \x09 Horizontal tab

```yaml
sdwan:
  edge_feature_templates:
    banner_templates:
      - name: FT-CEDGE-BANNER-07
        description: Banner template with ASCII Carriage return, Line Feed and horizontal tab
        device_types:
          - C8000V
          - ISR-4331
        login: "Login**********************************************************************\x0d\x0aLogin next line"
        motd: "MOTD***************************************************************\x0D\x0AMOTD next\x09line"
```

