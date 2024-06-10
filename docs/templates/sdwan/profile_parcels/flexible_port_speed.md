# Flexible Port Speed Profile Parcel

Set the Flexible Port Speed configuration.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        flexible_port_speed:
          name: flexible_port_speed
          description: basic flexible port speed
          port_type: 8 ports of 1/10GE + 4 ports of 40GE
```
