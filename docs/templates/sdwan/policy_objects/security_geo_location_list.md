# Security Geo Location List

A security geo-location list is a collection of geographic locations, specified by continent and country codes, used to configure next-generation firewall (NGFW) policies within policy groups.

{{ doc_gen }}

### Examples

Example 1: This example demonstrates the configuration of a security geo-location list that includes the continents Europe and North America, as well as the country India, represented using both continent and country code formats.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_geo_location_lists:
        - name: sec_geo_list1
          continent_codes:
            - EU
            - NA
          country_codes:
            - IND
```
