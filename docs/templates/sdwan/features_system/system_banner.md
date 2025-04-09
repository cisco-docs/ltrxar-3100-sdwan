# System Banner Feature

Configure the login banner or message-of-the-day banner.

{{ doc_gen }}

### Examples

Example-1: This example is showing a basic single line MOTD banner and multi line login banner. Use \n for newlines.
```yaml
sdwan:
  edge_feature_templates:
    banner_templates:
      name: banner
      description: basic banner
      login: |
        This is line 1 of banner.
        This is line 2 of banner.
      motd_variable: This is a sample MOTD banner.
```

Example-2: This example is showing a multi line login banner with special field to provide identification of device one is connecting to.
```yaml
sdwan:
  edge_feature_templates:
    banner_templates:
      - name: FT-EDGE-BANNER-01
        description: Login banner for devices
        login: |
          ***************************************************************
          *                                                             *
          *                   Access is restricted!                     *
          *                                                             *
          * Unauthorized access or use of this equipment is prohibited! *
          *      If you are not authorized to use this system,          *
          *              terminate this session now.                    *
          *                                                             *
          *                All activities are recorded.                 *
          ***************************************************************
          
          Device: $(hostname)
          
```
