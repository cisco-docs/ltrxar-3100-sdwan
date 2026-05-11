# Application Priority Settings

Cisco SD-WAN app-visibility and flow-visibility are traffic monitoring features enabled within policy groups to provide deep packet inspection (DPI) and application-aware analytics:
- Before using these settings, configure cflowd collectors in SD-WAN Manager: `Configuration > Network Hierarchy > Collectors > Cflowd`.
- cflowd collector configuration is global and not site-specific.
- These settings are applied to SD-WAN controllers when deploying application priority and SLA policy.

{{ doc_gen }}

## Example

Example 1: This example demonstrates how to enable ipv4 application and flow visibility in the application priority profile. (ipv4/ipv6 visibility settings are disabled by default)

```yaml
sdwan:
  feature_profiles:
    application_priority_profiles:
      - name: app_priority_profile
        settings:
          ipv4_application_visibility: true
          ipv4_flow_visibility: true
```
