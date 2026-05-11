# NGFW Security Feature Profile

Using an NGFW security profile, you can configure next-generation firewall (NGFW) policies and settings for unified threat defense on your SD-WAN devices.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an NGFW security feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    ngfw_security_profiles:
      - name: ngfw_profile
        description: NGFW security profile
```
