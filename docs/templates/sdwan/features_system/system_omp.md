# System OMP Feature

Change the graceful restart timers and advertisement timers and hold timers; change the number of paths advertised; configure an AS overlay number; choose which local protocols will be advertised into OMP; and change the number of equal-cost paths installed in the WAN Edge router.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        omp:
          name: omp
          description: basic omp
          ecmp_limit_variable: omp_ecmp_limit
          graceful_restart: true
          send_path_limit: 16
          graceful_restart_timer: 86400
          advertise_ipv4_connected: true
          advertise_ipv4_bgp: false
          advertise_ipv6_bgp_variable: omp_advertise_ipv6_bgp
```
