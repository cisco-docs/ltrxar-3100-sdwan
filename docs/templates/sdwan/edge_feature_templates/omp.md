# OMP Feature Template

Change the graceful restart timers and advertisement timers and hold timers; change the number of paths advertised; configure an AS overlay number; choose which local protocols will be advertised into OMP; and change the number of equal-cost paths installed in the WAN Edge router.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    omp_templates:
      - name: FT-CEDGE-OMP-01
        description: "OMP base template"
        ecmp_limit_variable: omp_ecmp_limit
        graceful_restart: true
        send_path_limit: 16
        graceful_restart_timer: 86400
        ipv4_advertise_protocols:
          - connected
          - bgp
          - ospf
```
